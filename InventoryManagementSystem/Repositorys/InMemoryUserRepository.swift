final class InMemoryUserRepository: UserRepository {
    
    private var users: [Int: User] = [:]
    private var nextUserId: Int = 1
    
    func getNextUserId() -> Int {
        defer { nextUserId += 1 }
        return nextUserId
    }
    
    func saveUser(_ user: User) {
        return users[user.userId] = user
    }
    
    func findByEmailAndRole(
        email: String,
        role: UserRole
    ) -> User? {
        users.values.first {
            $0.email == email && $0.role == role
        }
    }

    
    func findById(_ id: Int) -> User? {
        return users[id]
    }
}
