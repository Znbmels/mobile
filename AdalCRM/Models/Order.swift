import Foundation

struct Order: Codable {
    let id: Int
    let orderNumber: String
    let clientName: String
    let clientPhone: String
    let status: OrderStatus
    let statusDisplay: String
    let managerName: String
    let courierName: String?
    let washerName: String?
    let washerAssistantName: String?
    let totalAmount: String
    let itemsCount: Int
    let createdAt: String
    let pickupDate: String?
    let deliveryDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case clientName = "client_name"
        case clientPhone = "client_phone"
        case status
        case statusDisplay = "status_display"
        case managerName = "manager_name"
        case courierName = "courier_name"
        case washerName = "washer_name"
        case washerAssistantName = "washer_assistant_name"
        case totalAmount = "total_amount"
        case itemsCount = "items_count"
        case createdAt = "created_at"
        case pickupDate = "pickup_date"
        case deliveryDate = "delivery_date"
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case created = "created"
    case assigned = "assigned"
    case pickedUp = "picked_up"
    case inWashing = "in_washing"
    case washed = "washed"
    case driedAndPacked = "dried_and_packed"
    case readyForDelivery = "ready_for_delivery"
    case delivered = "delivered"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .created:
            return "Создан"
        case .assigned:
            return "Назначен"
        case .pickedUp:
            return "Забран"
        case .inWashing:
            return "В стирке"
        case .washed:
            return "Постиран"
        case .driedAndPacked:
            return "Высушен и упакован"
        case .readyForDelivery:
            return "Готов к доставке"
        case .delivered:
            return "Доставлен"
        case .cancelled:
            return "Отменен"
        }
    }
    
    var color: UIColor {
        switch self {
        case .created, .assigned:
            return UIColor.systemRed
        case .pickedUp, .inWashing, .washed, .driedAndPacked, .readyForDelivery:
            return UIColor.systemGreen
        case .delivered:
            return UIColor.black
        case .cancelled:
            return UIColor.systemGray
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .created, .assigned:
            return UIColor.systemRed.withAlphaComponent(0.1)
        case .pickedUp, .inWashing, .washed, .driedAndPacked, .readyForDelivery:
            return UIColor.systemGreen.withAlphaComponent(0.1)
        case .delivered:
            return UIColor.black.withAlphaComponent(0.1)
        case .cancelled:
            return UIColor.systemGray.withAlphaComponent(0.1)
        }
    }
}

struct OrdersResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Order]
}

struct Statistics: Codable {
    let totalOrders: Int
    let totalAmount: Double
    let statusCounts: [String: StatusCount]
    
    enum CodingKeys: String, CodingKey {
        case totalOrders = "total_orders"
        case totalAmount = "total_amount"
        case statusCounts = "status_counts"
    }
}

struct StatusCount: Codable {
    let name: String
    let count: Int
}
