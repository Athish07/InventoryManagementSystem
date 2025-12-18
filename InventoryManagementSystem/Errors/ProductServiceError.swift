enum ProductServiceError:Error {
    case unauthorizedUserAccess
    case productNotFound
    
    
    var displayMessage : String {
        switch self {
        case .unauthorizedUserAccess:
            return "Unauthorized user access"
        case .productNotFound:
            return "Product not found"
        }
    }
}
