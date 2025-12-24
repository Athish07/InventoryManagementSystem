protocol UserRepository {
    func getNextUserId() -> Int
    func save(_ user: User)
    func findById(_ id: Int) -> User?
    func findByEmail(_ email: String) -> User?

}
