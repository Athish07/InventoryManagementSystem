enum OrderServiceError: Error {
    case orderNotFound
    case productNotFound
    case insufficientStock
    case cartEmpty
    
    var displayMessage: String {
        switch self {
        case .orderNotFound:
            return "Order not found."
        case .productNotFound:
            return "Product not found."
        case .insufficientStock:
            return "Insufficient stock."
        case .cartEmpty:
            return "Cart is empty."
        }
    }
    
}
