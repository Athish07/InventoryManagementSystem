protocol UserRepository {
    func saveUser(_ user: User)
    func findByEmail(_ email: String) -> User?
    func findById(_ id: Int) -> User?

}
