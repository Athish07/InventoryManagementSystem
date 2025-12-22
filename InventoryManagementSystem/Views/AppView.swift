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
    
    func readUserLogin() -> (email:String, password: String) {
       let email = ConsoleInputUtils.readNonEmptyString("")
       let password = ConsoleInputUtils.readNonEmptyString("")
        
        return (email,password)
    }
    
    func showCategoryMenu(_ categories: [ProductCategory]) {
        print("\nSelect a product category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All products")
        print("Select a category:")

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
    
}

