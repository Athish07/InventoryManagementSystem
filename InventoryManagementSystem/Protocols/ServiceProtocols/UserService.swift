protocol UserService {
    
    func getUser(by id: Int) -> User?
    func updateCustomer(userId: Int, update: UserDTO.CustomerUpdate)
    func updateSupplier(userId: Int, update: UserDTO.SupplierUpdate)
}
