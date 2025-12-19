struct CustomerView {
    
    func showCustomerMenu(userName: String , customerMenu: [CustomerMenu]) -> Int {
        print("\n--------------------------------------------")
        print("Welcome Customer, \(userName)")
        
        for (index,menu) in customerMenu.enumerated() {
            print("\(index+1) \(menu.rawValue)")
        }
        return readInt("Enter a choice: ")
    }
    
    func readCustomerDetails() -> User {
        let name = readNonEmptyString(prompt: "Enter your name:")
        let email = readNonEmptyString(prompt: "Enter your email:")
        let password = readNonEmptyString(prompt: "Enter your password:")
        let phone = readNonEmptyString(prompt: "Enter your phone number:")
        let shippingAddress = readNonEmptyString(
            prompt: "Enter your shipping address:"
        )
        
        return Customer()
    }
    
    func readUpdateCustomerDetails(customer: Customer) -> Customer
    {
        let nameInput = readString("Name (\(customer.name)):")
        let name = nameInput.isEmpty ? customer.name : nameInput
        
        let emailInput = readString("Email (\(customer.email)):")
        let email = emailInput.isEmpty ? customer.email: emailInput
        
        let phoneInput = readString("Phone (\(customer.phoneNumber)):")
        let phone = phoneInput.isEmpty ? customer.phoneNumber : phoneInput
        
        let shippingAddressInput = readString(
            "Shipping Address (\(customer.shippingAddress)):"
        )
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
    
}
