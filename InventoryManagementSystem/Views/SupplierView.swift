struct SupplierView {
    
    func showSupplierMenu(userName: String, supplierMenu: [SupplierMenu]) -> Int {
        print("\n--------------------------------------------")
        print("Welcome Supplier, \(userName)")
        
        for (index,menu) in supplierMenu.enumerated() {
            print("\(index+1). \(menu.rawValue)")
        }
        print("--------------------------------------------")
        return readInt("Enter a choice")
    }
    
    func readSupplierDetails() -> User {
        let name = readNonEmptyString(prompt: "Enter your name:")
        let email = readNonEmptyString(prompt: "Enter your email:")
        let password = readNonEmptyString(prompt: "Enter your password:")
        let phone = readNonEmptyString(prompt: "Enter your phone number:")
        let shippingAddress = readNonEmptyString(
            prompt: "Enter your shipping address:"
        )
        let companyName = readNonEmptyString(prompt: "Enter your company name:")
        let businessAddress = readNonEmptyString(
            prompt: "Enter your business address:"
        )
        
        return Supplier()
        
    }
    
    func readProductDetails() -> ProductInput {
        let name = readNonEmptyString(prompt: "Enter product name:")
        let category = readProductCategory()
        let unitPrice = readDouble("Enter unit price:")
        let quantity = readInt("Enter quantity:")
        
        return ProductInput(
            name: name,
            category: category,
            unitPrice: unitPrice,
            quantity: quantity
        )
        
    }
    
    func readUpdateSupplierDetails(supplier: Supplier) -> Supplier {
        
        let nameInput = readString("Name (\(supplier.name)):")
        let name = nameInput.isEmpty ? supplier.name : nameInput
        
        let emailInput = readString("Email (\(supplier.email)):")
        let email = emailInput.isEmpty ? supplier.email: emailInput
        
        let phoneInput = readString("Phone (\(supplier.phoneNumber)):")
        let phone = phoneInput.isEmpty ? supplier.phoneNumber : phoneInput
        
        let companyNameInput = readString(
            "Company Name (\(supplier.companyName)"
        )
        let companyName = companyNameInput.isEmpty ? supplier.companyName : companyNameInput
        
        let businessAddressInput = readString(
            "Business Address (\(supplier.businessAddress)):"
        )
        let businessAddress = businessAddressInput.isEmpty ? supplier.businessAddress : businessAddressInput
        
        return Supplier(
            userId: supplier.userId,
            name: name,
            email: email,
            password: supplier.password,
            phoneNumber: phone,
            companyName: companyName,
            businessAddress: businessAddress
        )
    }
    
    func readUpdateProductDetails( currentProduct: Product) -> Product {
        
        let nameInput = readString(
            "Product Name (\(currentProduct.name)):"
        )
        let name = nameInput.isEmpty ? currentProduct.name : nameInput
        
        let priceInput = Double(
            readString("Product price (\(currentProduct.unitPrice)):")
        )
        let price = priceInput == nil ? currentProduct.unitPrice : Double(
            priceInput!
        )
        
        let quantityInput = Int(
            readString("Product quantity (\(currentProduct.quantityInStock)):")
        )
        let quantity = quantityInput == nil ? currentProduct.quantityInStock : Int(
            quantityInput!
        )
        
        return Product(
            productId: currentProduct.productId,
            name: name,
            supplierId: currentProduct.supplierId,
            unitPrice: price,
            quantityInStock: quantity,
            category: currentProduct.category
        )
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
    
    private func readProductCategory() -> ProductCategory {
        let categories = ProductCategory.allCases
        
        print("Select category")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        
        let choice = readInt("Enter a choice(default category is other):")
        if choice > 0 && choice <= categories.count {
            return categories[choice - 1]
        }
        return .other
    }
    
}
