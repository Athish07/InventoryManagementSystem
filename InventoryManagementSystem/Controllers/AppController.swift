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
        let menu = view.getPublicMenuInput()

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
        let email = ConsoleInputUtils.readNonEmptyString("Email:")
        let password = ConsoleInputUtils.readNonEmptyString("Password:")

        view.readLoginRole(userRole: UserRole.allCases)
        let role = view.getLoginRoleInput()

        guard Validation.isValidEmail(email) else {
            view.showMessage("Invalid email format")
            return
        }
        guard Validation.isValidPassword(password) else {
            view.showMessage("Invalid password")
            return
        }

        do {
            currentUserId =
            try authenticationService
                .login(email: email, password: password, role: role)
            view.showMessage("Login successful.")
        } catch let error as LoginError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Unexpected error during login.")
        }
    }

    private func logout() {
        currentUserId = nil
        view.showMessage("Logged out successfully.")
    }

    private func searchProduct() {
        ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        )
    }

    private func register() {

        let registrationMenu = RegistrationMenu.allCases
        view.showRegistrationMenu(registrationMenu: registrationMenu)
        let menu = view.getRegistrationMenuInput()

        switch menu {
        case .customer: registerCustomer()
        case .supplier: registerSupplier()
        }

    }

    private func registerCustomer() {

        let customer = view.readCustomerRegistration()

        guard Validation.isValidEmail(customer.email) else {
            view
                .showMessage(
                    "Error: Invalid email format. Please check your input."
                )
            return
        }

        guard Validation.isValidPassword(customer.password) else {
            view
                .showMessage(
                    "Error: Password must be at least 6 characters long and must be less than 100 characters."
                )
            return
        }

        guard Validation.isValidPhoneNumber(customer.phoneNumber) else {
            view
                .showMessage(
                    "Error: Invalid phone number format. Please check your input."
                )
            return
        }

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

        guard Validation.isValidEmail(supplier.email) else {
            view
                .showMessage(
                    "Error: Invalid email format. Please check your input."
                )
            return
        }

        guard Validation.isValidPassword(supplier.password) else {
            view
                .showMessage(
                    "Error: Password must be at least 6 characters long and must be less than 100 characters."
                )
            return
        }

        guard Validation.isValidPhoneNumber(supplier.phoneNumber) else {
            view
                .showMessage(
                    "Error: Invalid phone number format. Please check your input."
                )
            return
        }

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
