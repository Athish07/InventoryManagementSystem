enum CustomerMenu: String,CaseIterable {
    
    case searchProduct
    case addItemToCart
    case removeItemFromCart
    case viewCart
    case checkout
    case viewOrders
    case viewProfile
    case onLogout
//   static func selectedChoice(choice: Int, menu: [CustomerMenu]) -> CustomerMenu? {
//        guard choice > 0 && choice <= menu.count else {
//            return nil
//        }
//        return menu[choice - 1]
//    }
    
}
