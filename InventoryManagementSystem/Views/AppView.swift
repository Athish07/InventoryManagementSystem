import Foundation

struct AppView {
    
    func showPublicMenu() -> Int {
        print("\n--------------------------------------------")
        print("Welcome to the Inventory Management System")
        print("1. Search Products")
        print("2. Login")
        print("3. Register")
        print("4. Exit")
        print("--------------------------------------------")
        return readInt("Enter a choice:")
    }
    
    func showCustomerMenu(userName: String) -> Int {
        print("\n--------------------------------------------")
        print("Welcome Customer, \(userName)")
        print("1. View Products")
        print("2. Add Item to Cart")
        print("3. Remove Item from Cart")
        print("4. View Cart")
        print("5. Checkout")
        print("6. View My Orders")
        print("7. View Profile")
        print("8. Logout")
        print("--------------------------------------------")
        return readInt("Enter a choice:")
    }

    
    func showSupplierMenu(userName: String) -> Int {
        print("\n--------------------------------------------")
        print("Welcome Supplier, \(userName)")
        print("1. Add Product")
        print("2. View My Products")
        print("3. Update Product")
        print("4. Delete Product")
        print("5. View Profile")
        print("6. Logout")
        print("--------------------------------------------")
        return readInt("Enter a choice")
    }

    func showRegistrationMenu() -> Int {
        print("1. Register as Supplier")
        print("2. Register as Customer")
        return readInt("Enter a choice:")
    }
    
    func readLoginRole() -> UserRole {
        print("Login as:")
        print("1. Customer")
        print("2. Supplier")

        let choice = readInt("Enter choice:")

        return choice == 1 ? .customer : .supplier
    }
    
    func readCommonUserDetails() -> CommonUserDetails {
        let name = readNonEmptyString(prompt: "Enter your name:")
        let email = readNonEmptyString(prompt: "Enter your email:")
        let password = readNonEmptyString(prompt: "Enter your password:")
        let phone = readNonEmptyString(prompt: "Enter your phone number:")

        return CommonUserDetails(
            name: name,
            email: email,
            password: password,
            phoneNumber: phone
        )
    }

    func readCustomerDetails() -> String {
        readNonEmptyString(prompt: "Enter your shipping address:")
    }

    func readSupplierDetails() -> (companyName: String, businessAddress: String) {
        let companyName = readNonEmptyString(prompt: "Enter your company name:")
        let businessAddress = readNonEmptyString(prompt: "Enter your business address:")
        return (companyName, businessAddress)
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
    
    func readUpdateCustomerDetails(customer: Customer) -> Customer
    {
        let nameInput = readString("Name (\(customer.name)):")
        let name = nameInput.isEmpty ? customer.name : nameInput
        
        let emailInput = readString("Email (\(customer.email)):")
        let email = emailInput.isEmpty ? customer.email: emailInput
        
        let phoneInput = readString("Phone (\(customer.phoneNumber)):")
        let phone = phoneInput.isEmpty ? customer.phoneNumber : phoneInput
        
        let shippingAddressInput = readString("Shipping Address (\(customer.shippingAddress)):")
        let shippingAddress = shippingAddressInput.isEmpty ? customer.shippingAddress : shippingAddressInput
        
        return Customer(
            userId: customer.userId,
            name: name,
            email: email,
            password: customer.password,
            phoneNumber: phone,
            shippingAddress: shippingAddress
        )
    }
    
    func readUpdateSupplierDetails(supplier: Supplier) -> Supplier {
        
        let nameInput = readString("Name (\(supplier.name)):")
        let name = nameInput.isEmpty ? supplier.name : nameInput
        
        let emailInput = readString("Email (\(supplier.email)):")
        let email = emailInput.isEmpty ? supplier.email: emailInput
        
        let phoneInput = readString("Phone (\(supplier.phoneNumber)):")
        let phone = phoneInput.isEmpty ? supplier.phoneNumber : phoneInput
        
        let companyNameInput = readString("Company Name (\(supplier.companyName)")
        let companyName = companyNameInput.isEmpty ? supplier.companyName : companyNameInput
        
        let businessAddressInput = readString("Business Address (\(supplier.businessAddress)):")
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
        
          let priceInput = Double(readString("Product price (\(currentProduct.unitPrice)):"))
          let price = priceInput == nil ? currentProduct.unitPrice : Double(priceInput!)

          let quantityInput = Int(readString("Product quantity (\(currentProduct.quantityInStock)):"))
          let quantity = quantityInput == nil ? currentProduct.quantityInStock : Int(quantityInput!)
        
          return Product(
              productId: currentProduct.productId,
              name: name,
              supplierId: currentProduct.supplierId,
              unitPrice: price,
              quantityInStock: quantity,
              category: currentProduct.category
          )
      }
        
    func showCategoryMenu(_ categories: [ProductCategory]) -> Int {
        print("\nSelect a product category:")
        for (index, category) in categories.enumerated() {
            print("\(index + 1). \(category.rawValue)")
        }
        print("\(categories.count + 1). All products")
        return readInt("Select a category:")
    }

    func showProducts(_ products: [Product]) {
        print("\nAvailable Products:")
        for product in products {
            print(
                "\(product.productId) | " +
                "\(product.name) | " +
                "\(product.category.rawValue) | " +
                "Price: \(product.unitPrice) | " +
                "Stock: \(product.quantityInStock)"
            )
        }
    }
    
    func showCart(_ cart: Cart) {
        print("\n---------------- CART ----------------")
        
        var total = 0.0

        for (index, item) in cart.items.enumerated() {
            print(
                "\(index + 1)| " +
                "Qty: \(item.quantity) | " +
                "Price: \(item.unitPrice) | " +
                "Total: \(item.itemTotal)"
            )
            total += item.itemTotal
        }

        print("--------------------------------------")
        print("Cart Total: \(total)")
        print("--------------------------------------")
    }
    
    func showCustomerProfile(_ customer: Customer) {
        print("\n--------------------------------------------")
        print("Name: \(customer.name)")
        print("Email: \(customer.email)")
        print("Phone: \(customer.phoneNumber)")
        print("Shipping Address: \(customer.shippingAddress)")
        print("--------------------------------------------")
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

        let choice = readInt("Enter a choice:")
        if choice > 0 && choice <= categories.count {
            return categories[choice - 1]
        }
        return .other
    }
    
    func showOrders(_ orders: [Order]) {
        if orders.isEmpty {
            print("No orders found.")
            return
        }

        for order in orders {
            print("\n--------------------------------------------")
            print("Order ID: \(order.orderId)")
            print("Date: \(order.dateOfPurchase.toIstString())")
            print("Status: \(order.status.rawValue)")
            print("Total Amount: \(order.totalAmount)")
            print("--------------------------------------------")
        }
    }
    
    func showMessage(_ message: String) {
        print(message)
    }
}

extension AppView {
    
    func readInt(_ prompt: String) -> Int {
        print(prompt, terminator: " ")
        while true {
            if let input = readLine(),
               let value = Int(input),
               value > 0 {
                return value
            }
            print("Enter a valid number:", terminator: "")
        }
    }
    
  
    
    private func readDouble(_ prompt: String) -> Double {
        print(prompt, terminator: " ")
        while true {
            if let input = readLine(),
               let value = Double(input),
               value > 0 {
                return value
            }
            print("Enter a valid number:",terminator: "")
        }
    }

    func readString(_ prompt: String) -> String {
        print(prompt, terminator: " ")
        return (readLine() ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func readNonEmptyString(prompt: String) -> String {
        while true {
            let value = readString(prompt)
            if !value.isEmpty {
                return value
            }
            print("Input cannot be empty.")
        }
    }
}
extension Date {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        return formatter
    }()
    func toIstString() -> String {
        Date.formatter.string(from: self)
    }
}
