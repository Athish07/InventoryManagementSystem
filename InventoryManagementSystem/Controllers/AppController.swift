import Foundation

final class AppController {

    private let view: AppView
    private let productSearchView: ProductSearchView
    private let authenticationService: AuthenticationService
    private let orderService: OrderService
    private let productService: ProductService
    private let userService: UserService
    private var currentUserId: Int?
    private let appFactory: AppFactory
    

    init(
        appView: AppView,
        authenticationService: AuthenticationService,
        orderService: OrderService,
        productService: ProductService,
        userService: UserService,
        productSearchView: ProductSearchView,
        appFactory: AppFactory
    ) {
        self.view = appView
        self.authenticationService = authenticationService
        self.orderService = orderService
        self.productService = productService
        self.userService = userService
        self.appFactory = appFactory
        self.productSearchView = productSearchView
    }

    func start() {
        while true {
            if let userId = currentUserId {
                handlePrivateNavigation(for: userId)
            } else {
                handlePublicMenu()
            }
        }
    }

    private func handlePublicMenu() {
        let publicMenu = PublicMenu.allCases
        view.showPublicMenu(publicMenu: publicMenu)
        let choice = ConsoleInputUtils.getMenuChoice()

        guard let menu = MenuSelectionHelper.select(userChoice: choice, options: publicMenu) else {
            MessagePrinter.errorMessage("Invalid Choice. Please try again.")
            return
        }
                
        switch menu {
        case .searchProducts: searchProduct()
        case .login: login()
        case .register: register()
        }
    }

    private func handlePrivateNavigation(for userId: Int) {
        guard let user = userService.getUser(by: userId) else {
            logout()
            return
        }

        if let customer = user as? Customer {
            appFactory
                .makeCustomerController(
                    customerId: customer.userId,
                    onLogout: { [weak self] in self?.logout()
                    }
                )
                .handleMenu(for: customer.name)

        } else if let supplier = user as? Supplier {
            appFactory
                .makeSupplierController(
                    supplierId: supplier.userId,
                    onLogout: {
                        [weak self] in self?.logout()
                    }
                )
                .handleMenu(for: supplier.name)
        }
    }
    
    private func login() {
        let userRoles = UserRole.allCases
        view.showLoginRole(userRole: userRoles)
        let choice = ConsoleInputUtils.getMenuChoice()
        
        guard let role = MenuSelectionHelper.select(userChoice: choice, options: userRoles) else {
            MessagePrinter.infoMessage("Invalid choice,try again.")
            return
        }
        
        let input = view.readUserLogin()
        
        do {
            currentUserId = try authenticationService.login(email: input.email, password: input.password, role: role)
            MessagePrinter.successMessage("Login successful.")
        } catch let error as LoginError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage("Unexpected error during login.")
        }
    }

    private func logout() {
        currentUserId = nil
        MessagePrinter.successMessage("Logged out successfully.")
    }

    private func searchProduct() {
        ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        )
    }

    private func register() {

        let registrationMenu: [RegistrationMenu] = [.customer, .supplier]
        view.showRegistrationMenu(registrationMenu: registrationMenu)
        let choice = ConsoleInputUtils.getMenuChoice()
        
        guard let menu = MenuSelectionHelper.select(userChoice: choice, options: registrationMenu) else {
            MessagePrinter.infoMessage("Invalid Choice. Please try again.")
            return
        }
        
        
        switch menu {
        case .customer: registerCustomer()
        case .supplier: registerSupplier()
        }

    }

    private func registerCustomer() {

        let customer = view.readCustomerRegistration()

        guard Validation.isValidEmail(customer.email) else {
            MessagePrinter
                .errorMessage(
                    "Error: Invalid email format. Please check your input."
                )
            return
        }

        guard Validation.isValidPassword(customer.password) else {
            MessagePrinter
                .errorMessage(
                    "Error: Password must be at least 6 characters long and must be less than 100 characters."
                )
            return
        }

        guard Validation.isValidPhoneNumber(customer.phoneNumber) else {
            MessagePrinter
                .errorMessage(
                    "Error: Invalid phone number format. Please check your input."
                )
            return
        }

        do {
            try authenticationService.registerCustomer(input: customer)
            MessagePrinter.successMessage("Customer registered successfully.")
        } catch let error as RegistrationError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage("Registration failed.")
        }

    }

    private func registerSupplier() {
        let supplier = view.readSupplierRegistration()

        guard Validation.isValidEmail(supplier.email) else {
            MessagePrinter
                .errorMessage(
                    "Error: Invalid email format. Please check your input."
                )
            return
        }

        guard Validation.isValidPassword(supplier.password) else {
            MessagePrinter
                .errorMessage(
                    "Error: Password must be at least 6 characters long and must be less than 100 characters."
                )
            return
        }

        guard Validation.isValidPhoneNumber(supplier.phoneNumber) else {
            MessagePrinter
                .errorMessage(
                    "Error: Invalid phone number format. Please check your input."
                )
            return
        }

        do {
            try authenticationService.registerSupplier(input: supplier)
            MessagePrinter.successMessage("Supplier registered successfully.")
        } catch let error as RegistrationError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage("Registration failed.")
        }
    }
}
