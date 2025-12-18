final class InMemoryOrderItemRepository: OrderItemRepository {
    
    private var items: [Int: OrderItem] = [:]

    func save(_ item: OrderItem) {
        items[item.orderItemId] = item
    }

    func getByOrder(orderId: Int) -> [OrderItem] {
        items.values.filter { $0.orderId == orderId }
    }
}

