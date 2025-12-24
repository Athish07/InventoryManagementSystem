import Foundation

struct ConsoleInputUtils {

    static func getMenuChoice() -> Int {
        return readInt("Enter a choice: ")
    }

    static func readInt(_ prompt: String = "") -> Int {
        while true {
            if !prompt.isEmpty {
                print(prompt, terminator: " ")
            }

            if let input = readLine(),
                let value = Int(input)
            {
                return value
            }

            print("Please enter a valid number.")
        }

    }

    static func readNonZeroInt(_ prompt: String) -> Int {
        while true {
            let value = readInt(prompt)
            if value > 0 {
                return value
            }
            print("Value must be greater than zero.")
        }
    }

    static func readDouble(_ prompt: String = "") -> Double {
        while true {
            if !prompt.isEmpty {
                print(prompt, terminator: " ")
            }

            if let input = readLine(),
                let value = Double(input)
            {
                return value
            }

            print("Please enter a valid number.")
        }

    }

    static func readNonEmptyString(_ prompt: String) -> String {
        while true {
            print(prompt, terminator: " ")

            if let input = readLine(),
                !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {

                return input
            }
            print("This field cannot be empty.")

        }

    }

    static func readOptionalString(_ prompt: String) -> String? {
        print(prompt, terminator: " ")

        guard let input = readLine() else {
            return nil
        }

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed

    }

    static func readOptionalInt(_ prompt: String) -> Int? {
        print(prompt, terminator: " ")

        guard let input = readLine() else {
            return nil
        }

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return nil
        }
        return Int(trimmed)

    }

    static func readOptionalDouble(_ prompt: String) -> Double? {
        print(prompt, terminator: " ")

        guard let input = readLine() else {
            return nil
        }

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return nil
        }
        return Double(trimmed)

    }

    static func readValidEmail() -> String {
        while true {
            let email = readNonEmptyString("Email:")
            if Validation.isValidEmail(email) {
                return email
            }
            print("Invalid email format.")
        }

    }

    static func readValidPassword() -> String {
        while true {
            let password = readNonEmptyString("Password:")
            if Validation.isValidPassword(password) {
                return password
            }
            print(
                "Password must be at least 6 characters and less than 10 characters."
            )
        }

    }

    static func readValidPhoneNumber() -> String {
        while true {
            let phone = readNonEmptyString("Phone:")
            if Validation.isValidPhoneNumber(phone) {
                return phone
            }
            print("Invalid phone number format.")
        }
    }

    static func readOptionalValidEmail(current: String) -> String? {
        while true {
            let input = readOptionalString(
                "Email (\(current)):"
            )

            guard let input else {
                return nil
            }

            if Validation.isValidEmail(input) {
                return input
            }
            print("Invalid email format.")
        }
    }

    static func readOptionalValidPhone(
        current: String
    ) -> String? {
        while true {
            let input = readOptionalString(
                "Phone (\(current)):"
            )

            guard let input else {
                return nil
            }

            if Validation.isValidPhoneNumber(input) {
                return input
            }

            print("Invalid phone number.")
        }
    }

}
