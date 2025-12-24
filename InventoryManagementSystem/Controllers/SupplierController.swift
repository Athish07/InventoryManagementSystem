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
        
        let menu: SupplierMenu = ConsoleMenuHelper.readValidMenu(
            show: { view.showSupplierMenu(userName: name, menus: supplierMenu)
            },
            read: { view.readSupplierMenu(supplierMenu: supplierMenu) },
            onInvalid: {
                view.showMessage("Invalid choice. Please try again.")
            })
        
        
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
        
        guard let (user, supplier) = requireSupplier() else {
            return
        }
        
        view.showSupplierProfile(user: user, supplier: supplier)
    }

    private func addProduct() {
        
        let input = view.readProductCreateInput()
        
        productService.addProduct(productDetails: input, supplierId: supplierId)
        view.showMessage("Product added successfully.")
    }

    private func updateProfile() {
        guard let (user, supplier) = requireSupplier() else {
            return
        }
        
        let updatedSupplier = view.readUpdateSupplierDetails(
            user: user,
            supplier: supplier
        )
        userService.updateSupplier(userId: supplierId, update: updatedSupplier)
    }

    @discardableResult
    private func viewMyProducts() -> [Product]? {

        guard let products = productService.searchProductsBySupplier(
            supplierId: supplierId
        ) else {
            view.showMessage("No products found.")
            return nil
        }
        
        view.showMyProducts(products)
        return products
    }

    private func updateProduct() {
        
        guard let products = viewMyProducts() else {
            return
        }
           
        let productId = view.readProductId(
            from: products,
            prompt: "Select the product ID to update: "
        )

        guard let product = products.first(where: { $0.productId == productId }) else {
            return
        }
        
        let input = view.readUpdateProductDetails(currentProduct: product)
        
        do {
            try productService
                .updateProduct(update: input, supplierId: supplierId)
            view.showMessage("Product Updated Successfully")
        } catch let error as ProductServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }
    
    private func requireSupplier() -> (User, Supplier)? {
        guard let user = userService.getUser(by: supplierId),
              let supplier = user.supplierProfile else {
            view.showMessage("Unauthorized access. Please login again.")
            return nil
        }
        return (user, supplier)
    }
    
    private func deleteProduct() {
        
        guard let products = productService.searchProductsBySupplier(
            supplierId: supplierId
        ) else {
            view.showMessage("No products found.")
            return
        }
        view.showMyProducts(products)
        let productId = view.readProductId(
            from: products,
            prompt: "Select the product ID to delete: "
        )
        
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
