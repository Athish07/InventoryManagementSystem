protocol ProductRepository {
    
    func addProduct(_ product: Product)
    func removeProduct(_ productId: Int)
    func getProductBySupplier(_ supplierId: Int) -> [Product]
    func getAllProducts() -> [Product]
    func getProductByCategory(_ category: ProductCategory) -> [Product]
    func getProductById(_ productId: Int) -> Product?
    func deleteProduct(_ id: Int)
    func getNextProductId() -> Int
    
}

