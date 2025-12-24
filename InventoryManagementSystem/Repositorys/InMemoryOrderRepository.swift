final class InMemoryOrderRepository: OrderRepository {

    private var orders: [Int: Order] = [:]
    private var nextOrderId: Int = 1

    func getNextOrderId() -> Int {
        defer { nextOrderId += 1 }
        return nextOrderId
    }

    func save(_ order: Order) {
        orders[order.orderId] = order
    }

    func getByCustomer(customerId: Int) -> [Order] {
        orders.values.filter { $0.customerId == customerId }
    }
}
