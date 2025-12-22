struct ProductSearchHelper {

    static func search(
        productService: ProductService,
        view: ProductSearchView
    ) {
        let category = view.showCategoryMenu(
            categories: ProductCategory.allCases
        )

        let products = productService.searchProductsByCategory(
            category: category
        )

        guard !products.isEmpty else {
            view.showMessage("No products found.")
            return
        }

        view.showProducts(products)
    }
}

