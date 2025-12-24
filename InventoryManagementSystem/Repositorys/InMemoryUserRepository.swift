final class InMemoryUserRepository: UserRepository {
    private var users: [Int: User] = [:]
    private var nextUserId: Int = 1

    func getNextUserId() -> Int {
        nextUserId += 1
        return nextUserId
    }

    func save(_ user: User) {
        users[user.userId] = user
        return
    }

    func findById(_ id: Int) -> User? {
        return users[id]
    }

    func findByEmail(_ email: String) -> User? {
        users.values.first { $0.email == email }
    }
}
