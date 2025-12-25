import Foundation

final class SupplierController {

    private let supplierView: SupplierView
    private let productService: ProductService
    private let userService: UserService
    private let productSearchView: ProductSearchView
    private let supplierId: Int
    private let onLogout: () -> Void

    init(
        view: SupplierView,
        productService: ProductService,
        supplierId: Int,
        userService: UserService,
        productSearchView: ProductSearchView,
        onLogout: @escaping () -> Void
    ) {
        self.supplierView = view
        self.productService = productService
        self.supplierId = supplierId
        self.userService = userService
        self.productSearchView = productSearchView
        self.onLogout = onLogout
    }

    func handleMenu() {

        let menus = SupplierMenu.allCases

        let menu: SupplierMenu = ConsoleMenuHelper.readValidMenu(
            show: {
                supplierView.showSupplierMenu(
                    userName: getUserName(),
                    menus: menus
                )
            },
            read: {
                supplierView.readSupplierMenu(supplierMenu: menus)
            },
            onInvalid: {
                supplierView.showMessage("Invalid choice. Please try again.")
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
        supplierView.showSupplierProfile(user: user, supplier: supplier)
    }

    private func updateProfile() {

        guard let (user, supplier) = requireSupplier() else { return }

        let input = supplierView.readUpdateSupplierDetails(
            user: user,
            supplier: supplier
        )

        userService.updateUser(
            userId: supplierId,
            name: input.name,
            phone: input.phoneNumber,
            email: input.email
        )

        userService.updateSupplier(
            userId: supplierId,
            companyName: input.companyName,
            businessAddress: input.businessAddress
        )

        supplierView.showMessage("Profile updated successfully.")
    }

    private func requireSupplier() -> (User, Supplier)? {

        guard
            let user = userService.getUser(by: supplierId),
            let supplier = userService.getSupplier(userId: supplierId)
        else {
            supplierView.showMessage("Unauthorized access.")
            return nil
        }

        return (user, supplier)
    }

    private func getUserName() -> String {
        userService.getUser(by: supplierId)?.name ?? "Supplier"
    }

    private func addProduct() {

        let categories = ProductCategory.allCases
        productSearchView.showCategoryMenu(categories: categories)
        
        let category = productSearchView.readSingleCategory(
            categories: categories,
            defaultCategory: .other
        )

        let input = supplierView.readProductCreateInput(category: category)

        productService.addProduct(
            productDetails: input,
            supplierId: supplierId
        )
        supplierView.showMessage("Product added successfully.")

    }

    @discardableResult
    private func viewMyProducts() -> [Product]? {

        guard
            let products = productService.searchProductsBySupplier(
                supplierId: supplierId
            )
        else {
            supplierView.showMessage("No products found.")
            return nil
        }

        supplierView.showMyProducts(products)
        return products
    }

    private func updateProduct() {

        guard let products = viewMyProducts() else { return }

        guard
            let productId = supplierView.readProductId(
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

        let input = supplierView.readUpdateProductDetails(
            currentProduct: product
        )

        do {
            try productService.updateProduct(
                update: input,
                supplierId: supplierId
            )
            supplierView.showMessage("Product updated successfully.")
        } catch let error as ProductServiceError {
            supplierView.showMessage(error.displayMessage)
        } catch {
            supplierView.showMessage(error.localizedDescription)
        }
    }

    private func deleteProduct() {

        guard let products = viewMyProducts() else { return }

        guard
            let productId = supplierView.readProductId(
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
            supplierView.showMessage("Product deleted successfully.")
        } catch let error as ProductServiceError {
            supplierView.showMessage(error.displayMessage)
        } catch {
            supplierView.showMessage(error.localizedDescription)
        }
    }
}
