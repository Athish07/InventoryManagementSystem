struct ProductSearchView {

    //CR: Separate functionalities - show and read
    func showCategoryMenu(
        categories: [ProductCategory]
    ) -> ProductCategory? {

        print("\nSelect Category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All Products")

        let choice = ConsoleInputUtils.readInt("Enter choice:")

        if choice == categories.count + 1 {
            return nil
        }

        guard choice > 0 && choice <= categories.count else {
            print("Invalid choice.")
            return showCategoryMenu(categories: categories)
        }

        return categories[choice - 1]
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

    func showMessage(_ message: String) {
        print(message)
    }
}

