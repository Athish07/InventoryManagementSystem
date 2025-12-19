struct Customer: User {
    var userId: Int
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    let role: UserRole = .customer
    var shippingAddress: String
    
}
