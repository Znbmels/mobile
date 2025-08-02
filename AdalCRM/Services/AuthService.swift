import Foundation

class AuthService {
    static let shared = AuthService()
    
    private let baseURL = "http://127.0.0.1:8000/api"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Authentication
    
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let loginRequest = LoginRequest(username: username, password: password)
        
        guard let url = URL(string: "\(baseURL)/auth/login/") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    // Сохраняем токены и пользователя
                    self?.saveTokens(access: loginResponse.access, refresh: loginResponse.refresh)
                    self?.saveUser(loginResponse.user)
                    
                    completion(.success(loginResponse.user))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func logout() {
        // Удаляем токены и данные пользователя
        userDefaults.removeObject(forKey: "access_token")
        userDefaults.removeObject(forKey: "refresh_token")
        userDefaults.removeObject(forKey: "current_user")
        
        // Переходим на экран входа
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                sceneDelegate.window?.rootViewController = loginVC
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return getAccessToken() != nil && getCurrentUser() != nil
    }
    
    // MARK: - Token Management
    
    private func saveTokens(access: String, refresh: String) {
        userDefaults.set(access, forKey: "access_token")
        userDefaults.set(refresh, forKey: "refresh_token")
    }
    
    func getAccessToken() -> String? {
        return userDefaults.string(forKey: "access_token")
    }
    
    private func getRefreshToken() -> String? {
        return userDefaults.string(forKey: "refresh_token")
    }
    
    // MARK: - User Management
    
    private func saveUser(_ user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            userDefaults.set(userData, forKey: "current_user")
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    func getCurrentUser() -> User? {
        guard let userData = userDefaults.data(forKey: "current_user") else { return nil }
        
        do {
            return try JSONDecoder().decode(User.self, from: userData)
        } catch {
            print("Error decoding user: \(error)")
            return nil
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных"
        case .decodingError:
            return "Ошибка декодирования"
        }
    }
}
