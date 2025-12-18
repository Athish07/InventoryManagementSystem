enum RegistrationError: Error{
    case userAlreadyExists

    var displayMessage: String {
        switch self {
        case .userAlreadyExists: return "Error: An account already exists with this email."
        }
    }
}


