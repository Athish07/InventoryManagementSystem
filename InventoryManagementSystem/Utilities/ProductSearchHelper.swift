struct ProductSearchHelper {

    static func search(
        productService: ProductService,
        view: ProductSearchView
    ) {
        let productCategories = ProductCategory.allCases
        
        view.showCategoryMenu(categories: productCategories)
        
        let choice = ConsoleInputUtils.getMenuChoice()
        
        let category = MenuSelectionHelper.select(
            userChoice: choice,
            options: productCategories
        )
        
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

