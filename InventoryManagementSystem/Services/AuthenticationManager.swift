final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository
    private let customerRepository: CustomerRepository
    private let supplierRepository: SupplierRepository

    init(
        userRepository: UserRepository,
        customerRepository: CustomerRepository,
        supplierRepository: SupplierRepository
    ) {
        self.userRepository = userRepository
        self.customerRepository = customerRepository
        self.supplierRepository = supplierRepository
    }

    func login(email: String, password: String) throws -> Int {
        guard let user = userRepository.findByEmail(email),
            user.password == password
        else {
            throw LoginError.invalidCredentials
        }
        return user.userId
    }

    func registerCustomer(input: AuthDTO.CustomerRegistration) throws {

        let user =
            userRepository.findByEmail(input.email)
            ?? User(
                userId: userRepository.getNextUserId(),
                email: input.email,
                name: input.name,
                password: input.password,
                phoneNumber: input.phoneNumber
            )

        userRepository.save(user)

        guard !customerRepository.exists(userId: user.userId) else {
            throw RegistrationError.userAlreadyExists
        }

        customerRepository.save(
            Customer(
                userId: user.userId,
                shippingAddress: input.shippingAddress
            )
        )
    }

    func registerSupplier(input: AuthDTO.SupplierRegistration) throws {

        let user =
            userRepository.findByEmail(input.email)
            ?? User(
                userId: userRepository.getNextUserId(),
                email: input.email,
                name: input.name,
                password: input.password,
                phoneNumber: input.phoneNumber
            )

        userRepository.save(user)

        guard !supplierRepository.exists(userId: user.userId) else {
            throw RegistrationError.userAlreadyExists
        }

        supplierRepository.save(
            Supplier(
                userId: user.userId,
                companyName: input.companyName,
                businessAddress: input.businessAddress
            )
        )
    }
}
