struct Supplier: User {
    var userId: Int
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    let role: UserRole = .supplier
    var companyName: String
    var businessAddress: String

  

}
