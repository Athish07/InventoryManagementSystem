final class ProductManager: ProductService {

    private let productRepository: ProductRepository

    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }

    func addProduct(productDetails: ProductDTO.Create, supplierId: Int) {

        let product = Product(
            productId: productRepository.getNextProductId(),
            name: productDetails.name,
            supplierId: supplierId,
            unitPrice: productDetails.unitPrice,
            quantityInStock: productDetails.quantity,
            category: productDetails.category
        )
        productRepository.addProduct(product)

    }

    func searchProductsByCategory(category: ProductCategory?) -> [Product] {
        if let category = category {
            return productRepository.getProductByCategory(category)
        } else {
            return productRepository.getAllProducts()
        }
    }

    func searchProductsBySupplier(supplierId: Int) -> [Product] {

        return productRepository.getProductBySupplier(supplierId)
    }

    func updateProduct(update: ProductDTO.Update, supplierId: Int) throws {

        guard
            var product = productRepository.getProductById(
                update.productId
            )
        else {
            throw ProductServiceError.productNotFound
        }

        guard product.supplierId == supplierId else {
            throw ProductServiceError.unauthorizedUserAccess
        }

        if let name = update.name {
            product.name = name
        }

        if let price = update.unitPrice {
            product.unitPrice = price
        }

        if let quantity = update.quantity {
            product.quantityInStock = quantity
        }

        productRepository.addProduct(product)

    }

    func deleteProduct(productId: Int, supplierId: Int) throws {

        guard let product = productRepository.getProductById(productId) else {
            throw ProductServiceError.productNotFound
        }

        guard product.supplierId == supplierId else {
            throw ProductServiceError.unauthorizedUserAccess
        }

        productRepository.deleteProduct(productId)

    }

    func getProductById(productId: Int) -> Product? {

        productRepository.getProductById(productId)
    }

}
