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

    func handleMenu(for name: String) {

        let customerMenu = CustomerMenu.allCases
        
        let menu = view.readCustomerMenu(name: name, customerMenu: customerMenu)

        switch menu {
        case .searchProduct: searchProduct()
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

    private func searchProduct() {
        
        guard let products = ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        ) else {
            return
        }
        productSearchView.showProducts(products)
        
    }

    private func addItemToCart() {
        
        guard let products = ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        ) else {
            return
        }
        
        productSearchView.showProducts(products)
        
        let input = view.readAddToCartInput()
        
        do {
            try orderService.addItemToCart(
                customerId: customerId,
                productId: input.productId,
                quantity: input.quantity
            )
            MessagePrinter.infoMessage("Item added to cart.")
        } catch let error as OrderServiceError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage(error.localizedDescription)
        }
        
    }

    private func updateProfile() {
        guard let user = userService.getUser(by: customerId),
              let customer = user.customerProfile
              
        else {
            MessagePrinter.errorMessage(
                "Unauthorized access, please login again."
            )
            return
        }
        let updatedCustomer = view.readUpdateCustomer(
            user: user,
            customer:customer
        )
        userService.updateCustomer(userId: customerId, update: updatedCustomer)
        
    }

    private func viewCart() {
        let cart = orderService.viewCart(customerId: customerId)

        if cart.items.isEmpty {
            MessagePrinter.infoMessage("Your cart is empty.")
            return
        } else {
            view.showCart(cart)
        }

    }

    private func removeItemFromCart() {
        let cart = orderService.viewCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            MessagePrinter.errorMessage("Your cart is empty.")
            return
        }
        let index = view.readRemoveItemInput(cart: cart)
        let productId = cart.items[index].productId

        do {
            try orderService.removeItemFromCart(
                customerId: customerId,
                productId: productId
            )
        } catch let error as OrderServiceError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage(error.localizedDescription)
        }

        MessagePrinter.successMessage("Item removed from cart.")

    }

    private func checkout() {

        do {
            let order = try orderService.checkout(customerId: customerId)
            MessagePrinter
                .successMessage(
                    "Order placed successfully. Total: \(order.totalAmount)"
                )
        } catch let error as OrderServiceError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage(error.localizedDescription)
        }

    }

    private func viewOrders() {
        let orders = orderService.viewOrders(customerId: customerId)
        
        if orders.isEmpty {
            MessagePrinter.errorMessage("No order found.")
        }
        
        view.showOrders(orders)

    }

    private func viewProfile() {

        guard let user = userService.getUser(by: customerId),
              let customer = user.customerProfile
              
        else {
            MessagePrinter.errorMessage(
                "Unauthorized access, please login again."
            )
            return
        }
        view.showCustomerProfile(user: user,customer: customer)

    }
}
