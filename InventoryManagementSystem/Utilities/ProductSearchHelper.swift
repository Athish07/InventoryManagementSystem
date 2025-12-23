struct ProductSearchHelper {

    static func search(
        productService: ProductService,
        view: ProductSearchView
    ) -> [Product]? {
        let productCategories = ProductCategory.allCases
        let category = view.readCategoryMenu(
            productCategories: productCategories
        )
        
        let products = productService.searchProductsByCategory(
            category: category
        )

        if products.isEmpty {
            MessagePrinter.infoMessage("No products found.")
            return nil
        }
        
        return products
    }
}

