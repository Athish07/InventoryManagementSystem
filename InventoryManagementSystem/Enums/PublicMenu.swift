enum PublicMenu: String, CaseIterable {
    case searchProducts = "Search Products"
    case login = "Login"
    case register = "Register"
}

extension PublicMenu {
    
    static func fromChoice(_ choice: Int) -> PublicMenu? {
        let index = choice - 1
        
        if index >= 0 && index < PublicMenu.allCases.count {
             return PublicMenu.allCases[index]
        }
        return nil
    }
}
