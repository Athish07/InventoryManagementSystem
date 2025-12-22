import Foundation

final class OrderManager: OrderService {

    private let cartRepository: InMemoryCartRepository
    private let orderRepository: InMemoryOrderRepository
    private let orderItemRepository: InMemoryOrderItemRepository
    private let productRepository: ProductRepository

    init(
        cartRepository: InMemoryCartRepository,
        orderRepository: InMemoryOrderRepository,
        orderItemRepository: InMemoryOrderItemRepository,
        productRepository: ProductRepository
    ) {
        self.cartRepository = cartRepository
        self.orderRepository = orderRepository
        self.orderItemRepository = orderItemRepository
        self.productRepository = productRepository
    }

    func addItemToCart(
        customerId: Int,
        productId: Int,
        quantity: Int
    ) throws {

        guard let product = productRepository.getProductById(productId) else {
            throw OrderServiceError.productNotFound
        }

        guard product.quantityInStock >= quantity else {
            throw OrderServiceError.insufficientStock
        }

        var cart = cartRepository.getCart(customerId: customerId)

        let item = CartItem(
            productId: productId,
            quantity: quantity,
            unitPrice: product.unitPrice
        )

        cart.items.append(item)
        cartRepository.saveCart(cart)
    }

    func removeItemFromCart(customerId: Int, productId: Int) throws {
        var cart = cartRepository.getCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            throw OrderServiceError.cartEmpty
        }
        cart.items.removeAll { $0.productId == productId }
        cartRepository.saveCart(cart)

    }

    func viewCart(customerId: Int) -> Cart {
        cartRepository.getCart(customerId: customerId)
    }

    func checkout(customerId: Int) throws -> Order {

        let cart = cartRepository.getCart(customerId: customerId)

        guard !cart.items.isEmpty else {
            throw OrderServiceError.cartEmpty
        }

        let orderId = orderRepository.getNextOrderId()

        var totalAmount = 0.0

        for cartItem in cart.items {

            guard
                var product = productRepository.getProductById(
                    cartItem.productId
                )
            else {
                throw OrderServiceError.productNotFound
            }

            guard product.quantityInStock >= cartItem.quantity else {
                throw OrderServiceError.insufficientStock
            }

            product.quantityInStock -= cartItem.quantity
            productRepository.addProduct(product)

            let orderItem = OrderItem(
                orderItemId: orderItemRepository.getNextOrderItemId(),
                orderId: orderId,
                productId: cartItem.productId,
                quantity: cartItem.quantity,
                unitPrice: cartItem.unitPrice,
                itemTotal: cartItem.itemTotal
            )
            orderItemRepository.save(orderItem)

            totalAmount += cartItem.itemTotal
        }

        let order = Order(
            orderId: orderId,
            customerId: customerId,
            totalAmount: totalAmount,
            dateOfPurchase: Date(),
            status: .paid
        )

        orderRepository.save(order)
        cartRepository.clearCart(customerId: customerId)

        return order
    }

    func viewOrders(customerId: Int) -> [Order] {
        orderRepository.getByCustomer(customerId: customerId)
    }
}
