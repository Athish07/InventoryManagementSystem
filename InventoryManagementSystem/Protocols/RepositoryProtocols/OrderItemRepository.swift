protocol OrderItemRepository {
    func save(_ item: OrderItem)
    func getByOrder(orderId: Int) -> [OrderItem]
    func getNextOrderItemId() -> Int
    
}
