protocol AuthenticationService {
    func login(email: String, password: String) throws -> Int
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
