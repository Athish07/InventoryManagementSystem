final class UserManager: UserService {

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

    func getUser(by id: Int) -> User? {
        userRepository.findById(id)
    }

    func getCustomer(userId: Int) -> Customer? {
        customerRepository.find(userId: userId)
    }

    func getSupplier(userId: Int) -> Supplier? {
        supplierRepository.find(userId: userId)
    }

    func updateUser(
        userId: Int,
        name: String?,
        phone: String?,
        email: String?
    ) {
        guard var user = userRepository.findById(userId) else { return }

        if let name { user.name = name }
        if let phone { user.phoneNumber = phone }
        if let email { user.email = email }

        userRepository.save(user)
    }

    func updateCustomer(userId: Int, shippingAddress: String?) {
        guard var customer = customerRepository.find(userId: userId) else {
            return
        }
        if let shippingAddress { customer.shippingAddress = shippingAddress }
        customerRepository.save(customer)
    }

    func updateSupplier(
        userId: Int,
        companyName: String?,
        businessAddress: String?
    ) {
        guard var supplier = supplierRepository.find(userId: userId) else {
            return
        }
        if let companyName { supplier.companyName = companyName }
        if let businessAddress { supplier.businessAddress = businessAddress }
        supplierRepository.save(supplier)
    }
}
