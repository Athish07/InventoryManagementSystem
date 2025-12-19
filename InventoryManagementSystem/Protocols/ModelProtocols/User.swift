protocol User {
    var userId: Int { get }
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var phoneNumber: String { get set }
    var role: UserRole {get}
    
}
