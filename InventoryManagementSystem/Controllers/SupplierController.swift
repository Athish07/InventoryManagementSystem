import Foundation

final class SupplierController {

    private let view: SupplierView
    private let productService: ProductService
    private let userService: UserService
    private let onLogout: () -> Void
    private let supplierId: Int

    init(
        view: SupplierView,
        productService: ProductService,
        supplierId: Int,
        userService: UserService,
        onLogout: @escaping () -> Void
    ) {
        self.view = view
        self.productService = productService
        self.supplierId = supplierId
        self.userService = userService
        self.onLogout = onLogout
    }

    func handleMenu(for name: String) {

        let supplierMenu = SupplierMenu.allCases
        view.showSupplierMenu(userName: name, supplierMenu: supplierMenu)
        let choice = ConsoleInputUtils.getMenuChoice()
        
        guard let menu = MenuSelectionHelper.select(userChoice: choice, options: supplierMenu) else {
            MessagePrinter.errorMessage("Invalid Choice, try again.")
            return
        }
        
        switch menu {
        case .addProduct: addProduct()
        case .viewMyProducts: viewMyProducts()
        case .updateProduct: updateProduct()
        case .deleteProduct: deleteProduct()
        case .viewProfile: viewProfile()
        case .updateProfile: updateProfile()
        case .onLogout: onLogout()
        }
    }

    private func viewProfile() {
        guard let customer = userService.getUser(by: supplierId) as? Supplier
        else {
            MessagePrinter.errorMessage("Unauthorized access.please login again.")
            return
        }
        view.showSupplierProfile(customer)
    }

    private func addProduct() {
        let category = ProductCategory.allCases
        let input = view.readProductCreateInput()

        productService.addProduct(productDetails: input, supplierId: supplierId)
        MessagePrinter.successMessage("Product added successfully.")
    }

    private func updateProfile() {
        guard let supplier = userService.getUser(by: supplierId) as? Supplier
        else {
            MessagePrinter.errorMessage("Unauthorized access, please login again.")
            return
        }

        let updatedSupplier = view.readUpdateSupplierDetails(supplier: supplier)
        userService.updateSupplier(userId: supplierId, update: updatedSupplier)
    }

    private func viewMyProducts() {

        let products = productService.searchProductsBySupplier(
            supplierId: supplierId
        )

        if products.isEmpty {
            MessagePrinter.infoMessage("No products found.")
        } else {
            view.showMyProducts(products)
        }
    }

    private func updateProduct() {
        viewMyProducts()
        let productId = ConsoleInputUtils.readInt(
            "Provide the Id of the product to update:"
        )

        guard let product = productService.getProductById(productId: productId)
        else {
            MessagePrinter.infoMessage("No such product found.")
            return
        }
        let input = view.readUpdateProductDetails(currentProduct: product)
        do {
            try productService
                .updateProduct(update: input, supplierId: supplierId)
            MessagePrinter.successMessage("Product Updated Successfully")
        } catch let error as ProductServiceError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage(error.localizedDescription)
        }
    }

    private func deleteProduct() {
        viewMyProducts()
        let productId = ConsoleInputUtils.readInt(
            "Provide the Id of the product to delete:"
        )

        do {
            try productService
                .deleteProduct(productId: productId, supplierId: supplierId)
            MessagePrinter.successMessage("Product deleted successfully.")
        } catch let error as ProductServiceError {
            MessagePrinter.errorMessage(error.displayMessage)
        } catch {
            MessagePrinter.errorMessage(error.localizedDescription)
        }

    }
}
