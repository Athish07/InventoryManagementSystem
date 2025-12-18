protocol ProductService {
    func searchProductsByCategory(category: ProductCategory?) -> [Product]
    func addProduct(productDetails: ProductInput, supplierId: Int) 
    func searchProductsBySupplier(supplierId: Int) -> [Product]
    func getProductById(productId: Int) -> Product?
    func updateProduct(product: Product) 
    func deleteProduct(productId: Int, supplierId: Int) throws
    
}
