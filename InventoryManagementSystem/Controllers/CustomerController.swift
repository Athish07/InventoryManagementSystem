import Foundation

final class CustomerController {

    private let view: CustomerView
    private let productSearchView: ProductSearchView
    private let orderService: OrderService
    private let productService: ProductService
    private let userService: UserService
    private let customerId: Int
    private let onLogout: () -> Void

    init(
        view: CustomerView,
        productSearchView: ProductSearchView,
        orderService: OrderService,
        productService: ProductService,
        userService: UserService,
        customerId: Int,
        onLogout: @escaping () -> Void
    ) {
        self.view = view
        self.productSearchView = productSearchView
        self.orderService = orderService
        self.productService = productService
        self.userService = userService
        self.customerId = customerId
        self.onLogout = onLogout
    }

    func handleMenu() {

        let menus = CustomerMenu.allCases

        let menu: CustomerMenu = ConsoleMenuHelper.readValidMenu(
            show: {
                view.showCustomerMenu(userName: getUserName(), menus: menus)
            },
            read: {
                view.readCustomerMenu(customerMenu: menus)
            },
            onInvalid: {
                view.showMessage("Invalid choice. Please try again.")
            }
        )

        switch menu {
        case .searchProduct: searchAndShowProducts()
        case .addItemToCart: addItemToCart()
        case .removeItemFromCart: removeItemFromCart()
        case .viewCart: viewCart()
        case .checkout: checkout()
        case .viewOrders: viewOrders()
        case .viewProfile: viewProfile()
        case .updateProfile: updateProfile()
        case .onLogout: onLogout()
        }
    }

    private func viewProfile() {
        guard let (user, customer) = requireCustomer() else { return }
        view.showCustomerProfile(user: user, customer: customer)
    }

    private func updateProfile() {

        guard let (user, customer) = requireCustomer() else { return }

        let input = view.readUpdateCustomer(user: user, customer: customer)

        userService.updateUser(
            userId: customerId,
            name: input.name,
            phone: input.phoneNumber
        )

        userService.updateCustomer(
            userId: customerId,
            shippingAddress: input.shippingAddress
        )

        view.showMessage("Profile updated successfully.")
    }

    private func requireCustomer() -> (User, Customer)? {

        guard
            let user = userService.getUser(by: customerId),
            let customer = userService.getCustomer(userId: customerId)
        else {
            view.showMessage("Unauthorized access.")
            return nil
        }

        return (user, customer)
    }

    private func getUserName() -> String {
        userService.getUser(by: customerId)?.name ?? "Customer"
    }

    @discardableResult
    private func searchAndShowProducts() -> [Product]? {
        guard
            let products = ProductSearchHelper.search(
                productService: productService,
                view: productSearchView
            )
        else { return nil }

        productSearchView.showProducts(products)
        return products
    }

    private func addItemToCart() {

        guard let products = searchAndShowProducts() else { return }

        let input = view.readAddToCartInput(from: products)

        do {
            try orderService.addItemToCart(
                customerId: customerId,
                productId: input.productId,
                quantity: input.quantity
            )
            view.showMessage("Item added to cart.")
        } catch let error as OrderServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }

    private func removeItemFromCart() {

        let cart = orderService.viewCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            view.showMessage("Your cart is empty.")
            return
        }

        view.showCart(cart)
        guard let index = view.readRemoveItemInput(cart: cart) else {
            return
        }
        let productId = cart.items[index].productId

        do {
            try orderService.removeItemFromCart(
                customerId: customerId,
                productId: productId
            )
            view.showMessage("Item removed from cart.")
        } catch let error as OrderServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }

    private func viewCart() {

        let cart = orderService.viewCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            view.showMessage("Your cart is empty.")
            return
        }

        view.showCart(cart)
    }

    private func checkout() {

        do {
            let order = try orderService.checkout(customerId: customerId)
            view.showMessage(
                "Order placed successfully. Total: \(order.totalAmount)"
            )
        } catch let error as OrderServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }

    private func viewOrders() {

        let orders = orderService.viewOrders(customerId: customerId)

        if orders.isEmpty {
            view.showMessage("No orders found.")
        }

        view.showOrders(orders)
    }
}
