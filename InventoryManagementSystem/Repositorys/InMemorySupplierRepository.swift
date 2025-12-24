final class InMemorySupplierRepository: SupplierRepository {

    private var suppliers: [Int: Supplier] = [:]

    func exists(userId: Int) -> Bool {
        suppliers[userId] != nil
    }

    func save(_ supplier: Supplier) {
        suppliers[supplier.userId] = supplier
    }

    func find(userId: Int) -> Supplier? {
        suppliers[userId]
    }
    
}

