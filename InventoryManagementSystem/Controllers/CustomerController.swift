import Foundation

final class CustomerController {

    private let view: CustomerView
    private let orderService: OrderService
    private let productService: ProductService
    private let userService: UserService
    private let customerId: Int
    private let onLogout: () -> Void
    
    init(
        view: CustomerView,
        orderService: OrderService,
        productService: ProductService,
        userService: UserService,
        customerId: Int,
        onLogout: @escaping () -> Void
    ) {
        self.view = view
        self.orderService = orderService
        self.productService = productService
        self.userService = userService
        self.customerId = customerId
        self.onLogout = onLogout
    }

    func handleMenu(for name: String) {

        let customerMenu = CustomerMenu.allCases
        view.showCustomerMenu(
            userName: name,
            menus: customerMenu
        )
        
        switch view.getCustomerMenuInput() {
        case .searchProduct: searchProduct()
        case .addItemToCart: addItemToCart()
        case .removeItemFromCart: removeItemFromCart()
        case .viewCart: viewCart()
        case .checkout: checkout()
        case .viewOrders: viewOrders()
        case .viewProfile: viewProfile()
        case .onLogout: onLogout()
        }
    }

//    private func searchProduct() {
//        let categories = ProductCategory.allCases
//        view.showCategoryMenu(categories)
//        let category = view.getCategoryMenuInput(categories: categories)
//        
//        let products = productService.searchProductsByCategory(
//            category: selectedCategory
//        )
//        
//        if products.isEmpty {
//            view.showMessage("No products found.")
//        } else {
//            view.showProducts(products)
//        }
//    }

    private func addItemToCart() {
       // searchProduct()
        let productId = ConsoleInputUtils.readInt("Enter product id:")
        let quantity = ConsoleInputUtils.readInt("Enter quantity:")
        
        do {
            try orderService.addItemToCart(
                customerId: customerId,
                productId: productId,
                quantity: quantity
            )
            view.showMessage("Item added to cart.")
        } catch let error as OrderServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }
    
    private func updateProfile() {
        guard let customer = userService.getUser(by: customerId)as? Customer else {
            view.showMessage("Unauthorized access, please login again.")
            return
        }
        let updatedCustomer = view.readUpdateCustomer(customer)
        userService.updateCustomer(userId: customerId, update:updatedCustomer)
        
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

        let index = ConsoleInputUtils.readInt("Enter the index of the item to remove:")

        guard index > 0 && index <= cart.items.count else {
            view.showMessage("Invalid item index.")
            return
        }

        let productId = cart.items[index - 1].productId

        do {
            try orderService.removeItemFromCart(
                customerId: customerId,
                productId: productId
            ) } catch let error as OrderServiceError{
                view.showMessage(error.displayMessage)
            } catch {
                view.showMessage(error.localizedDescription)
            }

        view.showMessage("Item removed from cart.")
    }
    
    private func checkout() {
        
        do {
            let order = try orderService.checkout(customerId: customerId)
            view
                .showMessage(
                    "Order placed successfully. Total: \(order.totalAmount)"
                )
        } catch let error as OrderServiceError{
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }

    private func viewOrders() {
        let orders = orderService.viewOrders(customerId: customerId)
        view.showOrders(orders)
    }

    private func viewProfile() {
        
        guard let customer = userService.getUser(by: customerId) as? Customer else {
            view.showMessage("Unauthorized access, please login again.")
            return
        }
        view.showCustomerProfile(customer)
    }
}

