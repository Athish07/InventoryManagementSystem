class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository
    private static var nextUserId: Int = 1

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String) throws -> Int {
        
        guard let user = userRepository.findByEmail(email),
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
        
        guard userRepository.findByEmail(email) == nil else{
            throw RegistrationError.userAlreadyExists
        }
        
        let customer = Customer(
            userId: AuthenticationManager.nextUserId,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress
        )
        userRepository.saveUser(customer)
        AuthenticationManager.nextUserId += 1

    }

    func registerSupplier(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        companyName: String,
        businessAddress: String
    ) throws {
        
        guard userRepository.findByEmail(email) == nil else{
            throw RegistrationError.userAlreadyExists
        }
        
        let supplier = Supplier(
            userId: AuthenticationManager.nextUserId,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            companyName: companyName,
            businessAddress: businessAddress
        )
        userRepository.saveUser(supplier)
        AuthenticationManager.nextUserId += 1
    }

}
