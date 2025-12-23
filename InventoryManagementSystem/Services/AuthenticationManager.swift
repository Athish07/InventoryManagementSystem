final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String) throws -> Int {

        guard
            let user = userRepository.findByEmail(email),
            user.password == password
        else {
            throw LoginError.invalidCredentials
        }
        
        return user.userId
    }

    func registerCustomer(input: AuthDTO.CustomerRegistration) throws {

        if let existingUser = userRepository.findByEmail(input.email),
           existingUser.customerProfile != nil {
            throw RegistrationError.userAlreadyExists
        }
        
        let user: User
        if let existingUser = userRepository.findByEmail(input.email) {
            user = existingUser
        } else {
            user = User(
                userId: userRepository.getNextUserId(),
                name: input.name,
                email: input.email,
                password: input.password,
                phoneNumber: input.phoneNumber,
                customerProfile: nil,
                supplierProfile: nil
            )
        }

        var updatedUser = user
        updatedUser.customerProfile = Customer(
            shippingAddress: input.shippingAddress
        )

        userRepository.saveUser(updatedUser)

    }

    func registerSupplier(input: AuthDTO.SupplierRegistration) throws {

        if let existingUser = userRepository.findByEmail(input.email),
           existingUser.supplierProfile != nil {
            throw RegistrationError.userAlreadyExists
        }
        
        let user: User
        if let existingUser = userRepository.findByEmail(input.email) {
            user = existingUser
        } else {
            user = User(
                userId: userRepository.getNextUserId(),
                name: input.name,
                email: input.email,
                password: input.password,
                phoneNumber: input.phoneNumber,
                customerProfile: nil,
                supplierProfile: nil
            )
        }

        var updatedUser = user
        updatedUser.supplierProfile = Supplier(
            companyName: input.companyName,
            businessAddress: input.businessAddress
        )

        userRepository.saveUser(updatedUser)
    }

}
