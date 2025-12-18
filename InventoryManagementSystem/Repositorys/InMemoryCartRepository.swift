final class InMemoryCartRepository: CartRepository {

    private var carts: [Int: Cart] = [:]

    func getCart(customerId: Int) -> Cart {
        if let cart = carts[customerId] {
            return cart
        }
        let newCart = Cart(customerId: customerId)
        carts[customerId] = newCart
        return newCart
    }

    func saveCart(_ cart: Cart) {
        carts[cart.customerId] = cart
    }

    func clearCart(customerId: Int) {
        carts.removeValue(forKey: customerId)
    }
}

