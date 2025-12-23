import Foundation

final class AppController {

    private let view: AppView
    private let productSearchView: ProductSearchView
    private let authenticationService: AuthenticationService
    private let orderService: OrderService
    private let productService: ProductService
    private let userService: UserService
    private var currentUserId: Int?
    private var currentRole: UserRole?
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
        
        let menu = view.readPublicMenuChoice(publicMenu: publicMenu)
        
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

        if currentRole == .customer && user.customerProfile != nil {
            appFactory
                .makeCustomerController(
                    customerId: user.userId,
                    
                    onLogout: { [weak self] in self?.logout()
                    }
                )
                .handleMenu(for: user.name)

        } else if currentRole == .supplier  && user.supplierProfile != nil {
            appFactory
                .makeSupplierController(
                    supplierId: user.userId,
                    onLogout: {
                        [weak self] in self?.logout()
                    }
                )
                .handleMenu(for: user.name)
        }
    }
    
    private func login() {
        let userRoles = UserRole.allCases
        
        let role = view.readLoginRole(userRoles: userRoles)
        let input = view.readUserLogin()
        
        do {
            currentUserId = try authenticationService
                .login(email: input.email, password: input.password, role: role)
            currentRole = role
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

        let registrationMenu = RegistrationMenu.allCases
        let menu = view.readRegistrationMenu(registrationMenu: registrationMenu)
        
        switch menu {
        case .customer: registerCustomer()
        case .supplier: registerSupplier()
        }

    }

    private func registerCustomer() {

        let customer = view.readCustomerRegistration()
        
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
