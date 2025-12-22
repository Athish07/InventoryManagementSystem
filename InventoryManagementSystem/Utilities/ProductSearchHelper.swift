struct ProductSearchHelper {

    static func search(
        productService: ProductService,
        view: ProductSearchView
    ) {
        let productCategories = ProductCategory.allCases
        let category = view.readCategoryMenu(productCategories: productCategories)
        
        let products = productService.searchProductsByCategory(
            category: category
        )

        guard !products.isEmpty else {
            MessagePrinter.infoMessage("No products found.")
            return
        }

        view.showProducts(products)
    }
}

