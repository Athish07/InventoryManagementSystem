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

    func getCustomerMenuInput() -> CustomerMenu {
        while true {
            let choice = ConsoleInputUtils.readInt("Enter a choice:")
            if let menu = CustomerMenu.fromChoice(choice) {
                return menu
            }
            print("Invalid choice. Please try again.")
        }
    }

    func readUpdateCustomer(_ customer: Customer) -> UserDTO.CustomerUpdate {
       
        return UserDTO.CustomerUpdate(
                name: ConsoleInputUtils.readOptionalString(
                    "Name (\(customer.name)):"
                ),
                email: ConsoleInputUtils.readOptionalString(
                    "Email (\(customer.email)):"
                ),
                phoneNumber: ConsoleInputUtils.readOptionalString(
                    "Phone (\(customer.phoneNumber)):"
                ),
                shippingAddress: ConsoleInputUtils.readOptionalString(
                    "Address (\(customer.shippingAddress)):"
                )
            )
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
