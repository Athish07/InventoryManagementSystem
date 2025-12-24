final class InMemoryUserRepository: UserRepository {
    private var users: [Int: User] = [:]
    private var nextUserId: Int = 1
    
    func getNextUserId() -> Int {
        nextUserId += 1
        return nextUserId
    }
    
    func save(_ user: User) {
        return users[user.userId] = user
    }
    
    func findById(_ id: Int) -> User? {
        return users[id]
    }
    
    func findByEmail(_ email: String) -> User? {
        users.values.first { $0.email == email }
    }
}
