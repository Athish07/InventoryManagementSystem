import Foundation

struct Order {
    let orderId: Int
    let customerId: Int
    let totalAmount: Double
    let dateOfPurchase: Date
    let status: OrderStatus
}


