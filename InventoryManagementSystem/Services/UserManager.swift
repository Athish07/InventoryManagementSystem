struct UserManager: UserService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository)  {
        self.userRepository = userRepository
    }
    
    func getUser(by id: Int) -> User?
    {
        userRepository.findById(id)
    }
    
    func updateUser(_ user: User)
    {
        userRepository.saveUser(user)
    }
    
}
