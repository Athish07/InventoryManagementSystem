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
        switch view.getSupplierMenuInput() {
        case .addProduct: addProduct()
        case .viewMyProducts: viewMyProducts()
        case .updateProduct: updateProduct()
        case .deleteProduct: deleteProduct()
        case .viewProfile: viewProfile()
        case .onLogout: onLogout()
        }
    }

    private func viewProfile() {
        guard let customer = userService.getUser(by: supplierId) as? Supplier
        else {
            view.showMessage("Unauthorized access.please login again.")
            return
        }
        view.showSupplierProfile(customer)
    }

    private func addProduct() {
        let input = view.readProductCreateInput()

        productService.addProduct(productDetails: input, supplierId: supplierId)
        view.showMessage("Product added successfully.")
    }

    private func updateProfile() {
        guard let supplier = userService.getUser(by: supplierId) as? Supplier
        else {
            view.showMessage("Unauthorized access, please login again.")
            return
        }

        let updatedSupplier = view.readUpdateSupplierDetails(supplier: supplier)
        userService.updateUser(updatedSupplier)
    }

    private func viewMyProducts() {

        let products = productService.searchProductsBySupplier(
            supplierId: supplierId
        )

        if products.isEmpty {
            view.showMessage("No products found.")
        } else {
            view.showProducts(products)
        }
    }

    private func updateProduct() {
        viewMyProducts()
        let productId = ConsoleInputUtils.readInt("Provide the Id of the product to update:")

        guard let product = productService.getProductById(productId: productId)
        else {
            view.showMessage("No such product found.")
            return
        }
        let input = view.readUpdateProductDetails(currentProduct: product)
        productService.updateProduct(product: input)
        view.showMessage("Product Updated Successfully")
    }

    private func deleteProduct() {
        viewMyProducts()
        let productId = ConsoleInputUtils.readInt("Provide the Id of the product to delete:")

        do {
            try productService
                .deleteProduct(productId: productId, supplierId: supplierId)
            view.showMessage("Product deleted successfully.")
        } catch let error as ProductServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }

    }
}
