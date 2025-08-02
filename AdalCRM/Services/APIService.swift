import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://127.0.0.1:8000/api"
    
    private init() {}
    
    // MARK: - Orders
    
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        guard let user = AuthService.shared.getCurrentUser() else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        let endpoint: String
        switch user.role {
        case .courier:
            endpoint = "/courier/orders/"
        case .washer:
            endpoint = "/washer/orders/"
        case .washerAssistant:
            endpoint = "/washer-assistant/orders/"
        default:
            endpoint = "/orders/"
        }
        
        performRequest(endpoint: endpoint, method: "GET", completion: completion)
    }
    
    func updateOrderStatus(orderId: Int, status: OrderStatus, notes: String = "", completion: @escaping (Result<Order, Error>) -> Void) {
        guard let user = AuthService.shared.getCurrentUser() else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        let endpoint: String
        let requestBody: [String: Any] = ["status": status.rawValue, "notes": notes]
        
        switch user.role {
        case .courier:
            endpoint = "/courier/orders/\(orderId)/update-status/"
        case .washer:
            endpoint = "/washer/orders/\(orderId)/complete/"
        case .washerAssistant:
            endpoint = "/washer-assistant/orders/\(orderId)/update-status/"
        default:
            endpoint = "/orders/\(orderId)/update-status/"
        }
        
        performRequest(endpoint: endpoint, method: "POST", body: requestBody) { (result: Result<[String: Any], Error>) in
            switch result {
            case .success(let response):
                if let orderData = response["order"] as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: orderData)
                        let order = try JSONDecoder().decode(Order.self, from: jsonData)
                        completion(.success(order))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Statistics
    
    func fetchStatistics(completion: @escaping (Result<Statistics, Error>) -> Void) {
        guard let user = AuthService.shared.getCurrentUser() else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        let endpoint: String
        switch user.role {
        case .courier:
            endpoint = "/courier/statistics/"
        case .washer:
            endpoint = "/washer/statistics/"
        case .washerAssistant:
            endpoint = "/washer-assistant/statistics/"
        default:
            endpoint = "/statistics/"
        }
        
        performRequest(endpoint: endpoint, method: "GET", completion: completion)
    }
    
    // MARK: - Generic Request Method
    
    private func performRequest<T: Codable>(
        endpoint: String,
        method: String,
        body: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Добавляем токен авторизации
        if let token = AuthService.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Добавляем тело запроса если есть
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                    // Для массивов заказов нужна специальная обработка
                    if T.self == [Order].self {
                        if let ordersResponse = try? JSONDecoder().decode(OrdersResponse.self, from: data) {
                            completion(.success(ordersResponse.results as! T))
                        } else {
                            let orders = try JSONDecoder().decode([Order].self, from: data)
                            completion(.success(orders as! T))
                        }
                    } else {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
