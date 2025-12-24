protocol CustomerRepository {
    func exists(userId: Int) -> Bool
    func save(_ customer: Customer)
    func find(userId: Int) -> Customer?
}
