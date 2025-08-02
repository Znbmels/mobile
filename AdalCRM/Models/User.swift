import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    let role: UserRole
    let isActive: Bool
    let dateJoined: String
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, phone, role
        case firstName = "first_name"
        case lastName = "last_name"
        case isActive = "is_active"
        case dateJoined = "date_joined"
        case fullName = "full_name"
    }
}

enum UserRole: String, Codable, CaseIterable {
    case director = "director"
    case manager = "manager"
    case courier = "courier"
    case washer = "washer"
    case washerAssistant = "washer_assistant"
    
    var displayName: String {
        switch self {
        case .director:
            return "Директор"
        case .manager:
            return "Менеджер"
        case .courier:
            return "Курьер"
        case .washer:
            return "Мойщик"
        case .washerAssistant:
            return "Помощник мойщика"
        }
    }
    
    var iconName: String {
        switch self {
        case .director:
            return "person.3"
        case .manager:
            return "clipboard"
        case .courier:
            return "car"
        case .washer:
            return "drop"
        case .washerAssistant:
            return "person.badge.plus"
        }
    }
}

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let access: String
    let refresh: String
    let user: User
}
