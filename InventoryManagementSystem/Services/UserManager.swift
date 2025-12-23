final class UserManager: UserService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getUser(by id: Int) -> User? {
        userRepository.findById(id)
    }
    
    func updateCustomer(userId: Int, update: UserDTO.CustomerUpdate) {

        guard
            var user = userRepository.findById(userId),
            var customer = user.customerProfile
        else {
            return
        }
        
        if let name = update.name {
            user.name = name
        }

        if let email = update.email {
            user.email = email
        }

        if let phoneNumber = update.phoneNumber {
            user.phoneNumber = phoneNumber
        }
        
        if let shippingAddress = update.shippingAddress {
            customer.shippingAddress = shippingAddress
        }

        user.customerProfile = customer
        userRepository.saveUser(user)
    }
    
    func updateSupplier(userId: Int, update: UserDTO.SupplierUpdate) {

        guard
            var user = userRepository.findById(userId),
            var supplier = user.supplierProfile
        else {
            return
        }

       
        if let name = update.name {
            user.name = name
        }

        if let email = update.email {
            user.email = email
        }

        if let phoneNumber = update.phoneNumber {
            user.phoneNumber = phoneNumber
        }
        
        if let companyName = update.companyName {
            supplier.companyName = companyName
        }

        if let businessAddress = update.businessAddress {
            supplier.businessAddress = businessAddress
        }

        user.supplierProfile = supplier
        userRepository.saveUser(user)
    }
}

