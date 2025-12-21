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
        customer.name = update.name
        customer.phoneNumber = update.phoneNumber
        customer.shippingAddress = update.shippingAddress

        userRepository.saveUser(customer)
    }
    
    func updateSupplier(userId: Int, update: UserDTO.SupplierUpdate)
    {
        guard var supplier = userRepository.findById(userId) as? Supplier else {
            return
        }
        supplier.name = update.name
        supplier.phoneNumber = update.phoneNumber
        supplier.companyName = update.companyName
        supplier.businessAddress = update.businessAddress

        userRepository.saveUser(supplier)
    }
    
}
