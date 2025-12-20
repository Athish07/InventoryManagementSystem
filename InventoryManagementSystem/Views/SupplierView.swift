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
    
    func getSupplierMenuInput() -> SupplierMenu {
        while true {
            let choice = ConsoleInputUtils.readInt("Enter a choice:")
            if let menu = SupplierMenu.fromChoice(choice) {
                return menu
            }
            print("Invalid choice. Please try again.")
        }
    }
    
//    func readProductDetails() -> ProductInput {
//        let name = ConsoleInputUtils.readNonEmptyString("Enter product name:")
//        let category = readProductCategory()
//        let unitPrice = ConsoleInputUtils.readDouble("Enter unit price:")
//        let quantity = ConsoleInputUtils.readInt("Enter quantity:")
//        
//        return ProductInput(
//            name: name,
//            category: category,
//            unitPrice: unitPrice,
//            quantity: quantity
//        )
//        
//    }
    
    func readUpdateSupplierDetails(supplier: Supplier) -> Supplier {
        
        let name = ConsoleInputUtils.readOptionalString("Name (\(supplier.name)):") ?? supplier.name
        
        let email = ConsoleInputUtils.readOptionalString("Email (\(supplier.email)):") ?? supplier.email
        
        let phone = ConsoleInputUtils.readOptionalString("Phone (\(supplier.phoneNumber)):") ?? supplier.phoneNumber
        
        let companyName = ConsoleInputUtils.readOptionalString("Company Name (\(supplier.companyName)") ?? supplier.companyName
        
        let businessAddress = ConsoleInputUtils.readOptionalString("Business Address (\(supplier.businessAddress)):") ?? supplier.businessAddress
        
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
        
        let name = ConsoleInputUtils.readOptionalString("Product Name (\(currentProduct.name)):") ?? currentProduct.name
        
        let price = ConsoleInputUtils.readOptionalDouble("Product price (\(currentProduct.unitPrice)):") ?? currentProduct.unitPrice
        
        let quantity = ConsoleInputUtils.readOptionalInt("Product quantity (\(currentProduct.quantityInStock)):") ?? currentProduct.quantityInStock
        
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
    
    private func readProductCategory() {
        let categories = ProductCategory.allCases
        
        print("Select category")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("Enter a choice(default category is other):")
        
    }
    
    func showMessage(_ message: String) {
        print(message)
    }
    
}
