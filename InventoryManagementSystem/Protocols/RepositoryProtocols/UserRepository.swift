protocol UserRepository {
    func getNextUserId() -> Int
    func saveUser(_ user: User)
    func findByEmailAndRole(
        email: String,
        role: UserRole
    ) -> User?
    func findById(_ id: Int) -> User?

}
