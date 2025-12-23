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
        let menu = view.readSupplierMenu(name: name, supplierMenu: supplierMenu)
        
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
        guard let user = userService.getUser(by: supplierId),
              let supplier = user.supplierProfile
        else {
            MessagePrinter.errorMessage("Unauthorized access.please login again.")
            return
        }
        view.showSupplierProfile(user: user, supplier: supplier)
    }

    private func addProduct() {
        
        let input = view.readProductCreateInput()
        
        productService.addProduct(productDetails: input, supplierId: supplierId)
        MessagePrinter.successMessage("Product added successfully.")
    }

    private func updateProfile() {
        guard let user = userService.getUser(by: supplierId),
              let supplier = user.supplierProfile
        else {
            MessagePrinter.errorMessage("Unauthorized access, please login again.")
            return
        }

        let updatedSupplier = view.readUpdateSupplierDetails(user: user, supplier: supplier)
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
        
        let productId = view.readProductId(prompt: "Select the product to update")
        
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
        let productId = view.readProductId(prompt: "Select the product to delete")
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
