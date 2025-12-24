protocol SupplierRepository {
    func exists(userId: Int) -> Bool
    func save(_ supplier: Supplier)
    func find(userId: Int) -> Supplier?
}

