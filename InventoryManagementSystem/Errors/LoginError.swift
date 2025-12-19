enum LoginError: Error {
    case invalidCredentials
    
    var displayMessage: String {
        switch self {
        case .invalidCredentials:
            return "Login Failed: Invalid email or password or role."
        }
    }
}
