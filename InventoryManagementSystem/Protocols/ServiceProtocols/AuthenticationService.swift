protocol AuthenticationService {
    func login(
        email: String,
        password: String,
    ) throws -> Int
    func registerCustomer(input: AuthDTO.CustomerRegistration) throws
    func registerSupplier(input: AuthDTO.SupplierRegistration) throws
}
