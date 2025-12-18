import Foundation

struct SupplierController {
    
    private let view: AppView
    private let productService: ProductService
    private let userService: UserService
    
    private let supplierId: Int

    init(
        view: AppView,
        productService: ProductService,
        supplierId: Int,
        userService: UserService
    ) {
        self.view = view
        self.productService = productService
        self.supplierId = supplierId
        self.userService = userService
    }

    func handleMenu(for name: String) {
        switch view.showSupplierMenu(userName: name) {
        case 1: addProduct()
        case 2: viewMyProducts()
        case 3: updateProduct()
        case 4: deleteProduct()
        case 5: viewProfile()
        case 6: return
        default: view.showMessage("Invalid choice.")
        }
    }
    
    private func viewProfile() {
        guard let customer = userService.getUser(by: supplierId) as? Supplier else{
            view.showMessage("Unauthorized access.please login again.")
            return
        }
        view.showSupplierProfile(customer)
    }

    private func addProduct() {
        let input = view.readProductDetails()
        
        productService.addProduct(productDetails: input, supplierId: supplierId)
        view.showMessage("Product added successfully.")
    }
    
    private func updateProfile() {
        guard let supplier = userService.getUser(by: supplierId)as? Supplier else {
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
        let productId = view.readInt("Provide the Id of the product to update:")
        
        guard let product = productService.getProductById(productId: productId) else {
            view.showMessage("No such product found.")
            return
        }
        let input = view.readUpdateProductDetails(currentProduct: product)
        productService.updateProduct(product: input)
        view.showMessage("Product Updated Successfully")
    }

    private func deleteProduct() {
        viewMyProducts()
        let productId = view.readInt("Provide the Id of the product to delete:")
        
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
