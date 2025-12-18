final class InMemoryOrderRepository: OrderRepository {

    private var orders: [Int: Order] = [:]

    func save(_ order: Order) {
        orders[order.orderId] = order
    }

    func getByCustomer(customerId: Int) -> [Order] {
        orders.values.filter { $0.customerId == customerId }
    }
}

