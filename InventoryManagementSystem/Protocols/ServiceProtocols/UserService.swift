protocol UserService {
    
    func getUser(by id: Int) -> User?
    func updateUser(_ user: User)
}
