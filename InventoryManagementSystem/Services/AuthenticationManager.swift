final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String, role: UserRole) throws -> Int {

        guard
            let user = userRepository.findByEmailAndRole(
                email: email,
                role: role
            ),
            user.password == password
        else {
            throw LoginError.invalidCredentials
        }
        return user.userId
    }

    func registerCustomer(input: AuthDTO.CustomerRegistration) throws {

        guard
            userRepository
                .findByEmailAndRole(email: input.email, role: .customer) == nil
        else {
            throw RegistrationError.userAlreadyExists
        }

        let customer = Customer(
            userId: userRepository.getNextUserId(),
            name: input.name,
            email: input.email,
            password: input.password,
            phoneNumber: input.phoneNumber,
            shippingAddress: input.shippingAddress
        )
        userRepository.saveUser(customer)

    }

    func registerSupplier(input: AuthDTO.SupplierRegistration) throws {

        guard
            userRepository
                .findByEmailAndRole(email: input.email, role: .supplier) == nil
        else {
            throw RegistrationError.userAlreadyExists
        }

        let supplier = Supplier(
            userId: userRepository.getNextUserId(),
            name: input.name,
            email: input.email,
            password: input.password,
            phoneNumber: input.phoneNumber,
            companyName: input.companyName,
            businessAddress: input.businessAddress
        )
        userRepository.saveUser(supplier)
    }

}
