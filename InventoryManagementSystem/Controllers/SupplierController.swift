import Foundation

final class SupplierController {

    private let view: SupplierView
    private let productService: ProductService
    private let userService: UserService
    private let supplierId: Int
    private let onLogout: () -> Void

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

    func handleMenu() {

        let menus = SupplierMenu.allCases

        let menu: SupplierMenu = ConsoleMenuHelper.readValidMenu(
            show: {
                view.showSupplierMenu(userName: getUserName(), menus: menus)
            },
            read: {
                view.readSupplierMenu(supplierMenu: menus)
            },
            onInvalid: {
                view.showMessage("Invalid choice. Please try again.")
            }
        )

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
        guard let (user, supplier) = requireSupplier() else { return }
        view.showSupplierProfile(user: user, supplier: supplier)
    }

    private func updateProfile() {

        guard let (user, supplier) = requireSupplier() else { return }

        let input = view.readUpdateSupplierDetails(
            user: user,
            supplier: supplier
        )

        userService.updateUser(
            userId: supplierId,
            name: input.name,
            phone: input.phoneNumber
        )

        userService.updateSupplier(
            userId: supplierId,
            companyName: input.companyName,
            businessAddress: input.businessAddress
        )

        view.showMessage("Profile updated successfully.")
    }

    private func requireSupplier() -> (User, Supplier)? {

        guard
            let user = userService.getUser(by: supplierId),
            let supplier = userService.getSupplier(userId: supplierId)
        else {
            view.showMessage("Unauthorized access.")
            return nil
        }

        return (user, supplier)
    }

    private func getUserName() -> String {
        userService.getUser(by: supplierId)?.name ?? "Supplier"
    }

    private func addProduct() {

        let input = view.readProductCreateInput()
        productService.addProduct(productDetails: input, supplierId: supplierId)
        view.showMessage("Product added successfully.")
    }

    @discardableResult
    private func viewMyProducts() -> [Product]? {

        guard
            let products = productService.searchProductsBySupplier(
                supplierId: supplierId
            )
        else {
            view.showMessage("No products found.")
            return nil
        }

        view.showMyProducts(products)
        return products
    }

    private func updateProduct() {

        guard let products = viewMyProducts() else { return }

        guard
            let productId = view.readProductId(
                from: products,
                prompt:
                    "Select the product ID to update(ENTER -1 to move back):"
            )
        else {
            return
        }

        guard let product = products.first(where: { $0.productId == productId })
        else {
            return
        }

        let input = view.readUpdateProductDetails(currentProduct: product)

        do {
            try productService.updateProduct(
                update: input,
                supplierId: supplierId
            )
            view.showMessage("Product updated successfully.")
        } catch let error as ProductServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }

    private func deleteProduct() {

        guard let products = viewMyProducts() else { return }

        guard
            let productId = view.readProductId(
                from: products,
                prompt:
                    "Select the product ID to delete(ENTER -1 to move back):"
            )
        else {
            return
        }

        do {
            try productService.deleteProduct(
                productId: productId,
                supplierId: supplierId
            )
            view.showMessage("Product deleted successfully.")
        } catch let error as ProductServiceError {
            view.showMessage(error.displayMessage)
        } catch {
            view.showMessage(error.localizedDescription)
        }
    }
}

