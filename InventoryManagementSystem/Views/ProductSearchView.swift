struct ProductSearchView: ConsoleView {
    
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
    
    func readCategoryMenu(productCategories: [ProductCategory]) -> ProductCategory? {
        
        let choice = ConsoleInputUtils.getMenuChoice()
        
        if let selected = MenuSelectionHelper.select(
            userChoice: choice,
            options: productCategories
        ) {
            return selected
        } else if choice == productCategories.count + 1 {
            return nil
        }
        
        print("Invalid Choice(moving with all products option):")
        return nil
        
    }
}

