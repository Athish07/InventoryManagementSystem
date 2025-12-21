final class UserManager: UserService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository)  {
        self.userRepository = userRepository
    }
    
    func getUser(by id: Int) -> User?
    {
        userRepository.findById(id)
    }
    
    func updateCustomer(userId: Int, update: UserDTO.CustomerUpdate)
    {
        guard var customer = userRepository.findById(userId) as? Customer else {
            return
        }
        
        if let name = update.name {
            customer.name = name
        }
        
        if let phoneNumber = update.phoneNumber {
            customer.phoneNumber = phoneNumber
        }
        
        if let shippingAddress = update.shippingAddress {
            customer.shippingAddress = shippingAddress
        }
        userRepository.saveUser(customer)
    }
    
    func updateSupplier(userId: Int, update: UserDTO.SupplierUpdate)
    {
        guard var supplier = userRepository.findById(userId) as? Supplier else {
            return
        }
        
        if let name = update.name {
            supplier.name = name
        }
        
        if let phoneNumber = update.phoneNumber {
            supplier.phoneNumber = phoneNumber
        }
        
        if let companyName = update.companyName {
            supplier.companyName = companyName
        }
        
        if let businessAddress = update.businessAddress {
            supplier.businessAddress = businessAddress
        }
        
        userRepository.saveUser(supplier)
    }
    
}
