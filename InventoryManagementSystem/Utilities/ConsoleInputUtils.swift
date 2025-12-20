import Foundation

struct ConsoleInputUtils {
    
    static func readInt(_ prompt: String = "") -> Int {
        while true {
            if !prompt.isEmpty {
                print(prompt, terminator: " ")
            }

            if let input = readLine(),
               let value = Int(input) {
                return value
            }

            print("Please enter a valid number.")
        }
    }
    
    static func readDouble(_ prompt: String = "") -> Double {
        while true {
            if !prompt.isEmpty {
                print(prompt, terminator: " ")
            }

            if let input = readLine(),
               let value = Double(input) {
                return value
            }

            print("Please enter a valid number.")
        }
    }
    
    static func readNonEmptyString(_ prompt: String) -> String {
        while true {
            print(prompt, terminator: " ")

            if let input = readLine(),
               !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
}

