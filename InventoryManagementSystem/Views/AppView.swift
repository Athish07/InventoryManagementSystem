import Foundation

struct AppView {
    
    func showPublicMenu(publicMenu: [PublicMenu]) -> Int {
        print("\n--------------------------------------------")
        
        for (index,menu) in publicMenu.enumerated() {
            print("\(index+1). \(menu.rawValue)")
        }
        
        print("--------------------------------------------")
        return readInt("Enter a choice:")
    }
    
    func showRegistrationMenu(registrationMenu: [RegistrationMenu]) -> Int {
        
        for (index,menu) in registrationMenu.enumerated() {
            print("\(index+1).\(menu.rawValue)")
        }
        return readInt("Enter a choice:")
        
    }
    
    func readLoginRole(userRole: [UserRole]) -> UserRole {
        for (index,role) in userRole.enumerated() {
            print("\(index+1) \(role.rawValue)")
        }
        let choice = readInt("Enter choice:")
        
        let selectedRole = userRole[choice-1]
        return selectedRole
    }
    
    func showCategoryMenu(_ categories: [ProductCategory]) -> Int {
        print("\nSelect a product category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All products")
        let input = readInt("Select a category:")
        
        if input > categories.count+1 {
            print("Invalid category selection moving with All products option")
        }
        return input
        
    }
    
    func showProducts(_ products: [Product]) {
        print("\nAvailable Products:")
        for product in products {
            print(
                "\(product.productId) | " +
                "\(product.name) | " +
                "\(product.category.rawValue) | " +
                "Price: \(product.unitPrice) | " +
                "Stock: \(product.quantityInStock)"
            )
        }
    }
    
    func showMessage(_ message: String) {
        print(message)
    }
    
}

extension AppView {
    
    func readInt(_ prompt: String) -> Int {
        print(prompt, terminator: " ")
        while true {
            if let input = readLine(),
               let value = Int(input),
               value > 0 {
                return value
            }
            print("Enter a valid number:", terminator: "")
        }
    }
    
    private func readDouble(_ prompt: String) -> Double {
        print(prompt, terminator: " ")
        while true {
            if let input = readLine(),
               let value = Double(input),
               value > 0 {
                return value
            }
            print("Enter a valid number:",terminator: "")
        }
    }
    
    func readString(_ prompt: String) -> String {
        print(prompt, terminator: " ")
        return (readLine() ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func readNonEmptyString(prompt: String) -> String {
        while true {
            let value = readString(prompt)
            if !value.isEmpty {
                return value
            }
            print("Input cannot be empty.")
        }
    }
}

extension Date {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        return formatter
    }()
    func toIstString() -> String {
        Date.formatter.string(from: self)
    }
}
