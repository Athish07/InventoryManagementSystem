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
        
        var menu: CustomerMenu?
        
        while menu == nil {
            
            view.showCustomerMenu(userName: name, menus: customerMenu)
            menu = view.readCustomerMenu(customerMenu: customerMenu)
            if menu == nil {
                view.showMessage("Invalid choice. Please try again.")
            }
        }
        
        guard let selectedMenu = menu else {
            return
        }

        switch selectedMenu {
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
    
    @discardableResult
    private func searchAndShowProducts() -> [Product]? {
        guard let products = ProductSearchHelper.search(
            productService: productService,
            view: productSearchView
        ) else {
            return nil
        }

        productSearchView.showProducts(products)
        return products
    }


    private func addItemToCart() {
        
        guard let products = searchAndShowProducts() else {
            return
        }

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

    private func updateProfile() {
        guard let user = userService.getUser(by: customerId),
              let customer = user.customerProfile
              
        else {
            view.showMessage(
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
            view.showMessage("Your cart is empty.")
            return
        } else {
            view.showCart(cart)
        }

    }

    private func removeItemFromCart() {
        let cart = orderService.viewCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            view.showMessage("Your cart is empty.")
            return
        }
        view.showCart(cart)
        let index = view.readRemoveItemInput(cart: cart)
        let productId = cart.items[index].productId

        do {
            try orderService.removeItemFromCart(
                customerId: customerId,
                productId: productId
            )
        } catch let error as OrderServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }

        view.showMessage("Item removed from cart.")

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
            view.showMessage("No order found.")
        }
        
        view.showOrders(orders)

    }

    private func viewProfile() {

        guard let user = userService.getUser(by: customerId),
              let customer = user.customerProfile
              
        else {
            view.showMessage(
                "Unauthorized access, please login again."
            )
            return
        }
        view.showCustomerProfile(user: user,customer: customer)

    }
}
