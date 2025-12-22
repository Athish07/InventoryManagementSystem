import Foundation

enum Validation {

    private static let emailRegex =
    /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    public static func isValidEmail(_ email: String) -> Bool {

        return !email.isEmpty && email.wholeMatch(of: emailRegex) != nil
    }

    private static let phoneRegex = /^[6-9]\d{9}$/

    public static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        return !phoneNumber.isEmpty
        && phoneNumber
            .wholeMatch(of: phoneRegex) != nil
    }

    public static func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty && password.count >= 6 && password.count <= 10
    }

}
