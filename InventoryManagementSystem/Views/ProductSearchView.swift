struct ProductSearchView {
    
    //CR: Separate functionalities - show and read
    func showCategoryMenu(
        categories: [ProductCategory]
    ) {
        print("\nSelect Category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All Products")
        
    }
    
    func showProducts(_ products: [Product]) {
        for product in products {
            print("""
            -----------------------------------
            ID: \(product.productId)
            Name: \(product.name)
            Price: \(product.unitPrice)
            Stock: \(product.quantityInStock)
            Category: \(product.category.rawValue)
            -----------------------------------
            """)
        }
    }
    
    func readCategoryMenu(productCategories: [ProductCategory]) -> ProductCategory {
        while true {
            
            showCategoryMenu(categories: productCategories)
            let choice = ConsoleInputUtils.getMenuChoice()
            if let selected = MenuSelectionHelper.select(userChoice: choice, options: productCategories) {
                return selected
            }
            
            MessagePrinter.errorMessage("Invalid choice, try again.")
        }
    }
}

