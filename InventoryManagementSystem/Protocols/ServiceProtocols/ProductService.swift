protocol ProductService {
    func searchProductsByCategory(category: ProductCategory?) -> [Product]
    func addProduct(productDetails: ProductDTO.Create, supplierId: Int) 
    func searchProductsBySupplier(supplierId: Int) -> [Product]
    func getProductById(productId: Int) -> Product?
    func updateProduct(update: ProductDTO.Update, supplierId: Int) throws
    func deleteProduct(productId: Int, supplierId: Int) throws
    
}
