protocol AuthenticationService {
    func login(
        email: String,
        password: String,
        role: UserRole
    ) throws -> Int
    func registerCustomer(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        shippingAddress: String
    ) throws
    func registerSupplier(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        companyName: String,
        businessAddress: String
    ) throws
}
