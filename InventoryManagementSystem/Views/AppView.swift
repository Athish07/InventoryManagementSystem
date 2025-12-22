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
    
    func showRegistrationMenu(registrationMenu: [RegistrationMenu]) {
        for (index,menu) in registrationMenu.enumerated() {
            print("\(index+1).\(menu.rawValue)")
        }
        
    }
    
    func showLoginRole(userRole: [UserRole]) {
        for (index,role) in userRole.enumerated() {
            print("\(index+1) \(role.rawValue)")
        }
        
    }
    
    func showCategoryMenu(_ categories: [ProductCategory]) {
        print("\nSelect a product category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All products")
        
    }
    
    func readUserLogin() -> (email:String, password: String) {
        let email = ConsoleInputUtils.readValidEmail()
        let password = ConsoleInputUtils.readValidPassword()
        
        return (email,password)
    }
    
    func readPublicMenuChoice(publicMenu: [PublicMenu]) -> PublicMenu {
        
        while true {
            
            showPublicMenu(publicMenu: publicMenu)
            
            let choice = ConsoleInputUtils.getMenuChoice()
            
            if let selected = MenuSelectionHelper.select(userChoice: choice, options: publicMenu) {
               return selected
            }
            
            MessagePrinter.errorMessage("Invalid choice. Please try again.")
        }
        
    }
    
    func readLoginRole(userRoles: [UserRole]) -> UserRole {
        
        while true {
            
            showLoginRole(userRole: userRoles)
            
            let choice = ConsoleInputUtils.getMenuChoice()
            
            if let selected = MenuSelectionHelper.select(userChoice:choice, options: userRoles) {
                return selected
            }
            
            MessagePrinter.errorMessage("Invalid choice. Please try again.")

        }
    }
    
    func readRegistrationMenu(registrationMenu: [RegistrationMenu]) -> RegistrationMenu {
        
        while true {
            
            showRegistrationMenu(registrationMenu: registrationMenu)
            
            let choice = ConsoleInputUtils.getMenuChoice()
            
            if let selected = MenuSelectionHelper.select(userChoice: choice, options: registrationMenu) {
                return selected
            }
            
            MessagePrinter.errorMessage("Invalid choice. please try again.")
        }
    }
    
    func readCustomerRegistration() -> AuthDTO.CustomerRegistration {
        print("\n--- Customer Registration ---")

        let name = ConsoleInputUtils.readNonEmptyString("Name:")
        let email = ConsoleInputUtils.readValidEmail()
        let password = ConsoleInputUtils.readValidPassword()
        let phoneNumber = ConsoleInputUtils.readValidPhoneNumber()
        let shippingAddress = ConsoleInputUtils.readNonEmptyString(
            "Shipping Address:"
        )

        return AuthDTO.CustomerRegistration(
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress
        )
    }
    
    func readSupplierRegistration() -> AuthDTO.SupplierRegistration {
        let name = ConsoleInputUtils.readNonEmptyString("Name:")
        let email = ConsoleInputUtils.readValidEmail()
        let password = ConsoleInputUtils.readValidPassword()
        let phoneNumber = ConsoleInputUtils.readValidPhoneNumber()
        let companyName = ConsoleInputUtils.readNonEmptyString("Company Name:")
        let businessAddress = ConsoleInputUtils
            .readNonEmptyString("Business Address:")
        
        return AuthDTO.SupplierRegistration(
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            companyName: companyName,
            businessAddress: businessAddress
        )
    }
    
}

