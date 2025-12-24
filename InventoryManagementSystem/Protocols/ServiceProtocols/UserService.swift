protocol UserService {
    
    func getUser(by id: Int) -> User?
    func getCustomer(userId: Int) -> Customer?
    func getSupplier(userId: Int) -> Supplier?
    func updateUser(userId: Int, name: String?, phone: String?)
    func updateCustomer(userId: Int, shippingAddress: String?)
    func updateSupplier(userId: Int, companyName: String?, businessAddress: String?)
}
