protocol OrderService {
    func viewOrders(customerId: Int) -> [Order]
     func addItemToCart(
        customerId: Int,
        productId: Int,
        quantity: Int
     ) throws
    func viewCart(customerId: Int) -> Cart
    func checkout(customerId: Int) throws -> Order
    func removeItemFromCart(customerId: Int, productId: Int) throws
}
