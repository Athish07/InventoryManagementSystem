final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String, role: UserRole) throws -> Int {

        guard let user = userRepository.findByEmailAndRole(
            email: email,
            role: role
        ),
              user.password == password
        else {
            throw LoginError.invalidCredentials
        }
        return user.userId
    }

    func registerCustomer(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        shippingAddress: String
    ) throws {

        guard userRepository
            .findByEmailAndRole(email:email, role: .customer) == nil else {
            throw RegistrationError.userAlreadyExists
        }

        let customer = Customer(
            userId: userRepository.getNextUserId(),
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress
        )
        userRepository.saveUser(customer)

    }

    func registerSupplier(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        companyName: String,
        businessAddress: String
    ) throws {

        guard userRepository
            .findByEmailAndRole(email:email,role: .supplier) == nil else {
            throw RegistrationError.userAlreadyExists
        }

        let supplier = Supplier(
            userId: userRepository.getNextUserId(),
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            companyName: companyName,
            businessAddress: businessAddress
        )
        userRepository.saveUser(supplier)
    }

}
