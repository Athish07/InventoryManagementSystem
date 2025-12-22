enum UserRole: String, CaseIterable {
    case customer = "Customer"
    case supplier = "Supplier"
    
    static func fromChoice(_ choice: Int) -> UserRole? {
        let index = choice - 1
        
        if index >= 0 && index < UserRole.allCases.count {
            return UserRole.allCases[index]
        }
        return nil
        
    }
}
