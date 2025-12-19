import Foundation

final class AppController {

    private let view: AppView
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
        appFactory: AppFactory
    ) {
        self.view = appView
        self.authenticationService = authenticationService
        self.orderService = orderService
        self.productService = productService
        self.userService = userService
        self.appFactory = appFactory
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
        switch view.showPublicMenu() {
        case 1:
            searchProduct()
        case 2:
            login()
        case 3:
            register()
        case 4:
            exit(0)
        default:
            view.showMessage("Invalid choice.")
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
        let email = view.readString("Email:")
        let password = view.readString("Password:")
        let role = view.readLoginRole()

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
        let categories = ProductCategory.allCases
        let choice = view.showCategoryMenu(categories)
        let selectedCategory: ProductCategory? =
            (choice > 0 && choice <= categories.count)
            ? categories[choice - 1] : nil

        let products = productService.searchProductsByCategory(
            category: selectedCategory
        )
        if products.isEmpty {
            view.showMessage("No products found.")
        } else {
            view.showProducts(products)
        }
    }

    private func register() {
        let commonDetails = view.readCommonUserDetails()

        guard Validation.isValidEmail(commonDetails.email) else {
            view
                .showMessage(
                    "Error: Invalid email format. Please check your input."
                )
            return
        }

        guard Validation.isValidPassword(commonDetails.password) else {
            view
                .showMessage(
                    "Error: Password must be at least 6 characters long and less than 10 characters."
                )
            return
        }

        guard Validation.isValidPhoneNumber(commonDetails.phoneNumber) else {
            view
                .showMessage(
                    "Error: Invalid phone number format (use 10 digits)."
                )
            return
        }

        switch view.showRegistrationMenu() {
        case 1: registerSupplier(commonDetails)
        case 2: registerCustomer(commonDetails)
        default: view.showMessage("Invalid choice.")
        }
    }

    private func registerCustomer(_ details: CommonUserDetails) {
        let shippingAddress = view.readCustomerDetails()

        do {
            try authenticationService.registerCustomer(
                name: details.name,
                email: details.email,
                password: details.password,
                phoneNumber: details.phoneNumber,
                shippingAddress: shippingAddress
            )
            view.showMessage("Customer registered successfully.")
        } catch let error as RegistrationError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Registration failed.")
        }
    }

    private func registerSupplier(_ details: CommonUserDetails) {
        let supplierDetails = view.readSupplierDetails()

        do {
            try authenticationService.registerSupplier(
                name: details.name,
                email: details.email,
                password: details.password,
                phoneNumber: details.phoneNumber,
                companyName: supplierDetails.companyName,
                businessAddress: supplierDetails.businessAddress
            )
            view.showMessage("Supplier registered successfully.")
        } catch let error as RegistrationError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage("Registration failed.")
        }
    }
}
