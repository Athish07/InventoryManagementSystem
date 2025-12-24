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

        let menu: PublicMenu = ConsoleMenuHelper.readValidMenu(
            show: {
                view.showPublicMenu(publicMenu: publicMenu)
            },
            read: {
                view.readPublicMenuChoice(publicMenu: publicMenu)
            },
            onInvalid: { view.showMessage("Invalid choice. Please try again.") }
        )

        switch menu {
        case .searchProducts: searchAndShowProducts()
        case .login: login()
        case .register: register()
        case .exit: exit(0)

        }
    }

    private func handlePrivateNavigation(for userId: Int) {

        guard let role = currentRole else {
            logout()
            return
        }

        switch role {

        case .customer:
            guard userService.getCustomer(userId: userId) != nil else {
                view.showMessage("Customer role not found.")
                logout()
                return
            }

            appFactory
                .makeCustomerController(
                    customerId: userId,
                    onLogout: { [weak self] in self?.logout() }
                )
                .handleMenu()

        case .supplier:
            guard userService.getSupplier(userId: userId) != nil else {
                view.showMessage("Supplier role not found.")
                logout()
                return
            }

            appFactory
                .makeSupplierController(
                    supplierId: userId,
                    onLogout: { [weak self] in self?.logout() }
                )
                .handleMenu()
        }
    }

    private func login() {
        let userRoles = UserRole.allCases

        let role: UserRole = ConsoleMenuHelper.readValidMenu(
            show: {
                view.showLoginRole(userRole: userRoles)
            },
            read: { view.readLoginRole(userRoles: userRoles) },
            onInvalid: {
                view.showMessage("Invalid choice. please try again.")
            }
        )

        let input = view.readUserLogin()

        do {
            currentUserId =
                try authenticationService
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

    private func searchAndShowProducts() {
        guard
            let products = ProductSearchHelper.search(
                productService: productService,
                view: productSearchView
            )
        else {
            return
        }
        productSearchView.showProducts(products)
    }

    private func register() {

        let registrationMenu = RegistrationMenu.allCases

        let menu: RegistrationMenu = ConsoleMenuHelper.readValidMenu(
            show: {
                view.showRegistrationMenu(
                    registrationMenu: registrationMenu
                )
            },
            read: {
                view.readRegistrationMenu(registrationMenu: registrationMenu)
            },
            onInvalid: {
                view.showMessage("Invalid choice. Please try again.")
            }
        )

        switch menu {
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
