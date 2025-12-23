struct SupplierView: ConsoleView {
    
    func showSupplierMenu(userName: String, menus: [SupplierMenu]) {
        print("\n--------------------------------------------")
        print("Welcome Supplier, \(userName)")
        
        for (index,menu) in menus.enumerated() {
            print("\(index+1). \(menu.rawValue)")
        }
        print("--------------------------------------------")
    }
    
    func showMyProducts(_ products: [Product]) {
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
    
    func showSupplierProfile(user: User, supplier: Supplier) {
        print("\n--------------------------------------------")
        print("Name: \(user.name)")
        print("Email: \(user.email)")
        print("Phone: \(user.phoneNumber)")
        print("Company: \(supplier.companyName)")
        print("Business Address: \(supplier.businessAddress)")
        print("--------------------------------------------")
    }
    
    func readProductCreateInput() -> ProductDTO.Create {
        
        let name = ConsoleInputUtils.readNonEmptyString("Enter product name:")
        let category = readProductCategory()
        let unitPrice = ConsoleInputUtils.readDouble("Enter unit price:")
        let quantity = ConsoleInputUtils.readInt("Enter quantity:")
        
        return ProductDTO.Create(
            name: name,
            category: category,
            unitPrice: unitPrice,
            quantity: quantity
        )
        
    }
    
    func readSupplierMenu(supplierMenu: [SupplierMenu]) -> SupplierMenu? {
        
        let choice = ConsoleInputUtils.getMenuChoice()
        
        if let selected = MenuSelectionHelper.select(
            userChoice: choice,
            options: supplierMenu
        ) {
            return selected
        }
        
        return nil
        
    }
    
    
    func readUpdateSupplierDetails(user: User, supplier: Supplier) -> UserDTO.SupplierUpdate {
        
        let name = ConsoleInputUtils.readOptionalString(
            "Name (\(user.name)):"
        )

        let email = ConsoleInputUtils.readOptionalValidEmail(
            current: user.email
        )

        let phone = ConsoleInputUtils.readOptionalValidPhone(
            current: user.phoneNumber
        )

        let companyName = ConsoleInputUtils.readOptionalString(
            "Company Name (\(supplier.companyName)):"
        )

        let businessAddress = ConsoleInputUtils.readOptionalString(
            "Business Address (\(supplier.businessAddress)):"
        )

        return UserDTO.SupplierUpdate(
            name: name,
            email: email,
            phoneNumber: phone,
            companyName: companyName,
            businessAddress: businessAddress
        )
    }
    
    func readUpdateProductDetails( currentProduct: Product) -> ProductDTO.Update {
        
        let name = ConsoleInputUtils.readOptionalString(
            "Product Name (\(currentProduct.name)):"
        )
        let price = ConsoleInputUtils.readOptionalDouble(
            "Product price (\(currentProduct.unitPrice)):"
        )
        let quantity = ConsoleInputUtils.readOptionalInt(
            "Product quantity (\(currentProduct.quantityInStock)):"
        )
        
        return ProductDTO.Update(
            productId: currentProduct.productId,
            name: name,
            unitPrice: price,
            quantity: quantity,
        )
    }
    
    func readProductId(from products: [Product],prompt: String) -> Int {
        while true {
            
            let id = ConsoleInputUtils.readInt(prompt)
            
            if products.contains(where: { $0.productId == id }) {
                return id
            }
            
            print(
                "Invalid ID. Please choose an ID from the list displayed above."
            )
        }
    }
    
    private func readProductCategory() -> ProductCategory {
        let categories = ProductCategory.allCases

        print("\nSelect Category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("Press ENTER to select default: Other")

        let choice = ConsoleInputUtils.readOptionalInt("Enter choice:")
        
        guard let choice,
              let category = MenuSelectionHelper.select(
                userChoice: choice,
                options: categories
              ) else {
            return .other
        }

        return category
    }
    
}
