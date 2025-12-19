final class InMemoryProductRepository: ProductRepository {
  
    private var products: [Int: Product] = [:]
    private var nextProductId: Int = 1
    
    func getNextProductId() -> Int {
        defer { nextProductId += 1 }
        return nextProductId
    }
    
    func addProduct(_ product: Product) {
        products[product.productId] = product
    }

    func removeProduct(_ productId: Int) {
        products.removeValue(forKey: productId)
    }

    func getProductBySupplier(_ supplierId: Int) -> [Product] {
        products.values.filter { $0.supplierId == supplierId }
    }

    func getAllProducts() -> [Product] {
        Array(products.values)
    }

    func getProductByCategory(_ category: ProductCategory) -> [Product] {
        products.values.filter { $0.category == category }
    }
    
    func getProductById(_ id: Int) -> Product? {
        products[id]
    }
    
    func deleteProduct(_ id: Int) {
        products.removeValue(forKey: id)
    }
    
}


