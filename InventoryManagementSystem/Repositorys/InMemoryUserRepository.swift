class InMemoryUserRepository: UserRepository {
    
    private var users: [Int: User] = [:]
    
    func saveUser(_ user: User) {
       return users[user.userId] = user
    }
    
    func findByEmail(_ email: String) -> User? {
        return users.values.first(where: { $0.email == email })
    }
    
    func findById(_ id: Int) -> User? {
        return users[id]
    }
    
}
