import Foundation

final class CustomerController {

    private let view: AppView
    private let orderService: OrderService
    private let productService: ProductService
    private let userService: UserService
    private let customerId: Int
    private let onLogout: () -> Void
    
    init(
        view: AppView,
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

        switch view.showCustomerMenu(userName: name) {
        case 1: searchProduct()
        case 2: addItemToCart()
        case 3: removeItemFromCart()
        case 4: viewCart()
        case 5: checkout()
        case 6: viewOrders()
        case 7: viewProfile()
        case 8: onLogout()
        default:
            view.showMessage("Invalid choice.")
        }
    }

    private func searchProduct() {
        let categories = ProductCategory.allCases
        let choice = view.showCategoryMenu(categories)
        let selectedCategory =
        (choice > 0 && choice <= categories.count)
        ? categories[choice - 1]
        : nil

        let products = productService.searchProductsByCategory(
            category: selectedCategory
        )
        view.showProducts(products)
    }

    private func addItemToCart() {
        searchProduct()

        let productId = view.readInt("Enter product id:")
        let quantity = view.readInt("Enter quantity:")

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
        let updatedCustomer = view.readUpdateCustomerDetails(customer: customer)
        userService.updateUser(updatedCustomer)
    }
    
    private func viewCart() {
        let cart = orderService.viewCart(customerId: customerId)
       
        guard !cart.items.isEmpty else {
            view.showMessage("Your cart is empty.")
            return
        }
        view.showCart(cart)
        
    }
    
    private func removeItemFromCart() {
        let cart = orderService.viewCart(customerId: customerId)
        
        guard !cart.items.isEmpty else {
            view.showMessage("Your cart is empty.")
            return
        }
        view.showCart(cart)

        let index = view.readInt("Enter the index of the item to remove:")

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

