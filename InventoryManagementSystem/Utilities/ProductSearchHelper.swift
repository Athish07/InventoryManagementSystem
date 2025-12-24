struct ProductSearchHelper {

    static func search(
        productService: ProductService,
        view: ProductSearchView
    ) -> [Product]? {
        let productCategories = ProductCategory.allCases
        view.showCategoryMenu(categories: productCategories)

        let category = view.readCategoryMenu(
            productCategories: productCategories
        )

        let products = productService.searchProductsByCategory(
            category: category
        )

        if products.isEmpty {
            view.showMessage("No products found.")
            return nil
        }

        return products
    }
}
