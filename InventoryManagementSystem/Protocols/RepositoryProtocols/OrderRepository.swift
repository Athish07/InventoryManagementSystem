protocol OrderRepository {
    func save(_ order: Order)
    func getByCustomer(customerId: Int) -> [Order]
}
