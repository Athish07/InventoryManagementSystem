struct User {
    
    let userId: Int
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    
    var customerProfile: Customer?
    var supplierProfile: Supplier?
    
    var activeRoles: [UserRole] {
            var roles: [UserRole] = []
            if customerProfile != nil { roles.append(.customer) }
            if supplierProfile != nil { roles.append(.supplier) }
            return roles
        }
    
}
