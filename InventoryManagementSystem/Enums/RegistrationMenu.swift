enum RegistrationMenu: String, CaseIterable {
    case customer = "Customer"
    case supplier = "Supplier"
    
    static func fromChoice(_ choice:Int) -> RegistrationMenu? {
        let index = choice - 1
        
        if index >= 0 && index < RegistrationMenu.allCases.count {
            return RegistrationMenu.allCases[index]
        }
        return nil
    }
}
