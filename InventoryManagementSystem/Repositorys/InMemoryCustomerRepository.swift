final class InMemoryCustomerRepository: CustomerRepository {

    private var customers: [Int: Customer] = [:]

    func exists(userId: Int) -> Bool {
        customers[userId] != nil
    }

    func save(_ customer: Customer) {
        customers[customer.userId] = customer
    }

    func find(userId: Int) -> Customer? {
        customers[userId]
    }
}
