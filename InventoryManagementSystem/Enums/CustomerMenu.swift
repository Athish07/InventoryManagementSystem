enum CustomerMenu: String, CaseIterable {
    case searchProduct = "Serach Product"
    case addItemToCart = "Add Item to Cart"
    case removeItemFromCart = "Remove Item  From Cart"
    case viewCart = "View Cart"
    case checkout = "CheckOut"
    case viewOrders = "View Orders"
    case viewProfile = "View Profile"
    case onLogout = "Logout"
    
}

extension CustomerMenu {
    
    static func fromChoice(_ choice: Int) -> CustomerMenu? {
        let index = choice - 1
        
        if index >= 0 && index < CustomerMenu.allCases.count {
            return CustomerMenu.allCases[index]
        }
        return nil
    }

}
