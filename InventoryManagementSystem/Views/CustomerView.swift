import Foundation

struct CustomerView: ConsoleView {

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
                "\(index + 1). Qty: \(item.quantity) | Name: \(item.productName) | Price: \(item.unitPrice) | Total: \(item.itemTotal)"
            )

            total += item.itemTotal
        }

        print("--------------------------------------")
        print("Cart Total: \(total)")
        print("--------------------------------------")

    }

    func showCustomerProfile(user: User, customer: Customer) {
        print("\n--------------------------------------------")
        print("Name: \(user.name)")
        print("Email: \(user.email)")
        print("Phone: \(user.phoneNumber)")
        print("Shipping Address: \(customer.shippingAddress)")
        print("--------------------------------------------")

    }

    func showOrders(_ orders: [Order]) {

        for order in orders {
            print("\n--------------------------------------------")
            print("Order ID: \(order.orderId)")
            print("Date: \(order.dateOfPurchase.toISTString())")
            print("Status: \(order.status.rawValue)")
            print("Total Amount: \(order.totalAmount)")
            print("--------------------------------------------")
        }

    }

    func readCustomerMenu(customerMenu: [CustomerMenu]) -> CustomerMenu? {
        let choice = ConsoleInputUtils.getMenuChoice()
        return ConsoleMenuHelper.select(
            userChoice: choice,
            options: customerMenu
        )
    }

    func readUpdateCustomer(user: User, customer: Customer)
        -> UserDTO.CustomerUpdate
    {
        print("Press ENTER to keep the same data \n")

        let name = ConsoleInputUtils.readOptionalString(
            "Name (\(user.name)):"
        )
        let email = ConsoleInputUtils.readOptionalValidEmail(
            current: user.email
        )
        let phoneNumber = ConsoleInputUtils.readOptionalValidPhone(
            current: user.phoneNumber
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

    func readRemoveItemInput(cart: Cart) -> Int? {
        while true {

            let input = ConsoleInputUtils.readInt(
                "Enter the item number to remove(ENTER -1 to move back):"
            )
            
            if input == -1 {
                return nil
            }
            
            let index = input - 1

            if index >= 0 && index < cart.items.count {
                return index
            }

            print(
                "Invalid selection. Please choose a number within the given options."
            )
        }

    }

    func readAddToCartInput(from products: [Product]) -> (
        productId: Int,
        quantity: Int
    ) {

        var productId: Int

        while true {
            let input = ConsoleInputUtils.readInt("Enter product id:")

            if products.contains(where: { $0.productId == input }) {
                productId = input
                break
            }

            print(
                "Invalid product id. Please select from the listed products."
            )
        }

        let quantity = ConsoleInputUtils.readNonZeroInt("Enter quantity:")

        return (productId: productId, quantity: quantity)
    }

}

extension Date {

    func toISTString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")

        return formatter.string(from: self)

    }
}
