import Foundation

struct CustomerView {

    func showCustomerMenu(userName: String, menus: [CustomerMenu]) {
        print("\n--------------------------------------------")
        print("Welcome Customer, \(userName)")
        for (index, menu) in menus.enumerated() {
            print("\(index + 1). \(menu.rawValue)")
        }
        print("--------------------------------------------")
        
    }
    
    func showCart(_ cart: Cart) {
        print("\n---------------- CART ----------------")

        var total = 0.0
        for (index, item) in cart.items.enumerated() {
            print(
                "\(index + 1). Qty: \(item.quantity) | "
                + "Price: \(item.unitPrice) | " + "Total: \(item.itemTotal)"
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
            print("Date: \(order.dateOfPurchase.toISTString())")
            print("Status: \(order.status.rawValue)")
            print("Total Amount: \(order.totalAmount)")
            print("--------------------------------------------")
        }
        
    }
    
    func readCustomerMenu(name: String,customerMenu: [CustomerMenu]) -> CustomerMenu {
        while true {
            
            showCustomerMenu(userName: name, menus: customerMenu)
            let choice = ConsoleInputUtils.getMenuChoice()
            
            if let selected = MenuSelectionHelper.select(
                userChoice: choice,
                options: customerMenu
            ) {
                return selected
            }
            
            MessagePrinter.errorMessage("Invalid input , try again.")
        }
    }
    
    func readUpdateCustomer(_ customer: Customer) -> UserDTO.CustomerUpdate {
       
        let name =  ConsoleInputUtils.readOptionalString(
            "Name (\(customer.name)):"
        )
        let email =  ConsoleInputUtils.readOptionalValidEmail(
            current: customer.email
        )
        let phoneNumber = ConsoleInputUtils.readOptionalValidPhone(
            current: customer.phoneNumber
        )
        let shippingAddress = ConsoleInputUtils.readOptionalString(
            "Address (\(customer.shippingAddress)):"
        )
        
        return UserDTO.CustomerUpdate(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress
        )
        
    }
    
    func readRemoveItemInput(cart: Cart) -> Int {
        showCart(cart)
        
        let selected = ConsoleInputUtils.readIntInRange(
            min: 1,
            max: cart.items.count
        )
        
        return selected
    }
    
    func readAddToCartInput() -> (productId: Int, quantity: Int) {

        let productId = ConsoleInputUtils.readInt(
            "Enter product id:"
        )

        let quantity = ConsoleInputUtils.readInt(
            "Enter quantity:"
        )

        return (productId, quantity)
    }
    
}

extension Date {
    // CR: Reduce complexity.
    func toISTString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        
        return formatter.string(from: self)
        
    }
}
