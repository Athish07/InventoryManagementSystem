protocol CartRepository {
    func getCart(customerId: Int) -> Cart
    func saveCart(_ cart: Cart)
    func clearCart(customerId: Int)
}
