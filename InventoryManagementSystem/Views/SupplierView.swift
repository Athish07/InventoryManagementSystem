struct SupplierView {
    
    func showSupplierMenu(userName: String, supplierMenu: [SupplierMenu]) {
        print("\n--------------------------------------------")
        print("Welcome Supplier, \(userName)")
        
        for (index,menu) in supplierMenu.enumerated() {
            print("\(index+1). \(menu.rawValue)")
        }
        print("--------------------------------------------")
        print("Enter a choice:")
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
    
    func showSupplierProfile(_ supplier: Supplier) {
        print("\n--------------------------------------------")
        print("Name: \(supplier.name)")
        print("Email: \(supplier.email)")
        print("Phone: \(supplier.phoneNumber)")
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
    
    func readSupplierMenu(name: String,supplierMenu: [SupplierMenu]) -> SupplierMenu {
        
        while true {
            showSupplierMenu(userName: name, supplierMenu: supplierMenu)
            
            let choice = ConsoleInputUtils.getMenuChoice()
            
            if let selected = MenuSelectionHelper.select(userChoice: choice, options: supplierMenu) {
                return selected
            }
            
            MessagePrinter.errorMessage("Invalid input , try again.")
        }
        
    }
    
    
    func readUpdateSupplierDetails(supplier: Supplier) -> UserDTO.SupplierUpdate {
        
        let name = ConsoleInputUtils.readOptionalString(
            "Name (\(supplier.name)):"
        )

        let email = ConsoleInputUtils.readOptionalValidEmail(current: supplier.email)

        let phone = ConsoleInputUtils.readOptionalValidPhone(current: supplier.phoneNumber)

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
