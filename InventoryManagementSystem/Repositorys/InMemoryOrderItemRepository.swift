final class InMemoryOrderItemRepository: OrderItemRepository {

    private var items: [Int: OrderItem] = [:]
    private var nextOrderItemId: Int = 1

    func getNextOrderItemId() -> Int {
        defer { nextOrderItemId += 1 }
        return nextOrderItemId
    }

    func save(_ item: OrderItem) {
        items[item.orderItemId] = item
    }

    func getByOrder(orderId: Int) -> [OrderItem] {
        items.values.filter { $0.orderId == orderId }
    }
}
