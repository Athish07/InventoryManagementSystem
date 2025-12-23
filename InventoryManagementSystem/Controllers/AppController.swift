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
        
        var menu: PublicMenu?
        
        while menu == nil {
            view.showPublicMenu(publicMenu: publicMenu)
            menu = view.readPublicMenuChoice(publicMenu: publicMenu)
            if menu == nil {
                view.showMessage("Invalid choice. Please try again.")
            }
        }
        
        guard let selectedMenu = menu else {
            return
        }
        
        switch selectedMenu {
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
        var role: UserRole?
        
        while role == nil {
            view.showLoginRole(userRole: userRoles)
            role = view.readLoginRole(userRoles: userRoles)
            
            if role == nil {
                view.showMessage("Invalid choice. please try again.")
            }
        }
        
        let input = view.readUserLogin()
        do {
            currentUserId = try authenticationService
                .login(email: input.email, password: input.password)
            currentRole = role
            view.showMessage("Login successful.")
        } catch let error as LoginError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Unexpected error during login.")
        }
        
    }

    private func logout() {
        currentUserId = nil
        currentRole = nil
        view.showMessage("Logged out successfully.")
    }

    private func searchProduct() {
        guard let products = ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        ) else {
            return
        }
        productSearchView.showProducts(products)
    }

    private func register() {

        let registrationMenu = RegistrationMenu.allCases
       
        var menu: RegistrationMenu?
        
        while menu == nil {
            view.showRegistrationMenu(registrationMenu: registrationMenu)
            menu = view.readRegistrationMenu(registrationMenu: registrationMenu)
            
            if menu == nil {
                view.showMessage("Invalid choice. Please try again.")
            }
            
        }
        
        guard let selectedMenu = menu else {
            return
        }
        
        switch selectedMenu {
        case .customer: registerCustomer()
        case .supplier: registerSupplier()
        }

    }

    private func registerCustomer() {

        let customer = view.readCustomerRegistration()
        
        do {
            try authenticationService.registerCustomer(input: customer)
            view.showMessage("Customer registered successfully.")
        } catch let error as RegistrationError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Registration failed.")
        }

    }

    private func registerSupplier() {
        let supplier = view.readSupplierRegistration()
        
        do {
            try authenticationService.registerSupplier(input: supplier)
            view.showMessage("Supplier registered successfully.")
        } catch let error as RegistrationError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Registration failed.")
        }
    }
    
}
