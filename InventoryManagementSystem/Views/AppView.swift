import Foundation

struct AppView {
    
    func showPublicMenu(publicMenu: [PublicMenu]) {
        print("Welocome to Inventory Management System")
        print("\n--------------------------------------------")
        
        for (index,menu) in publicMenu.enumerated() {
            print("\(index+1). \(menu.rawValue)")
        }
        print("--------------------------------------------")
      
    }
    
    func getPublicMenuInput() -> PublicMenu {
        while true {
            print("Enter a choice:", terminator: "")
            let choice = ConsoleInputUtils.readInt()

            if let menu = PublicMenu.fromChoice(choice) {
                return menu
            }

            print("Invalid choice. Please try again.")
        }
    }
    
    func showRegistrationMenu(registrationMenu: [RegistrationMenu]) {
        
        for (index,menu) in registrationMenu.enumerated() {
            print("\(index+1).\(menu.rawValue)")
        }
        
    }
    
    func getRegistrationMenuInput() -> RegistrationMenu {
        while true {
            print("Enter a choice:", terminator: "")
            let choice = ConsoleInputUtils.readInt()
            
            if let menu = RegistrationMenu.fromChoice(choice) {
                return menu
            }
            print("Invalid choice. Please try again.")
        }
    }
    
    func readCustomerRegistration() -> AuthDTO.CustomerRegistration {
        .init(
            name: ConsoleInputUtils.readNonEmptyString("Name:"),
            email: ConsoleInputUtils.readNonEmptyString("Email:"),
            password: ConsoleInputUtils.readNonEmptyString("Password:"),
            phoneNumber: ConsoleInputUtils.readNonEmptyString("Phone:"),
            shippingAddress:
                ConsoleInputUtils
                .readNonEmptyString("Shipping Address:")
        )
    }
    
    func readSupplierRegistration() -> AuthDTO.SupplierRegistration {
        .init(
            name: ConsoleInputUtils.readNonEmptyString("Name:"),
            email: ConsoleInputUtils.readNonEmptyString("Email:"),
            password: ConsoleInputUtils.readNonEmptyString("Password:"),
            phoneNumber: ConsoleInputUtils.readNonEmptyString("Phone:"),
            companyName: ConsoleInputUtils.readNonEmptyString("Company Name:"),
            businessAddress: ConsoleInputUtils
                .readNonEmptyString("Business Address:")
        )
    }
    
    func readLoginRole(userRole: [UserRole]) {
        for (index,role) in userRole.enumerated() {
            print("\(index+1) \(role.rawValue)")
        }
        
    }
    
    func getLoginRoleInput() -> UserRole {
        
        while true {
            print("Enter choice:", terminator: "")
            let choice = ConsoleInputUtils.readInt()
            
            if let menu = UserRole.fromChoice(choice) {
                return menu
            }
            print("Invalid choice. Please try again.")
        }
    }
    
    func showCategoryMenu(_ categories: [ProductCategory]) {
        print("\nSelect a product category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All products")
        print("Select a category:")

    }
    
    func getCategoryMenuInput(
        categories: [ProductCategory]
    ) -> ProductCategory? {

        while true {
            let choice = ConsoleInputUtils.readInt("Enter a choice:")
            
            if choice == categories.count + 1 {
                return nil
            }

            if let category = ProductCategory.fromChoice(choice) {
                return category
            }

            print("Invalid choice. Please try again.")
        }
    }
    
    func showMessage(_ message: String) {
        print(message)
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
