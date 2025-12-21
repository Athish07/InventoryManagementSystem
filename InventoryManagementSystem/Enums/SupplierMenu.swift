enum SupplierMenu: String, CaseIterable {
    case addProduct = "Add Product"
    case viewMyProducts = "View My Products"
    case updateProduct = "Update Product"
    case deleteProduct = "Delete Product"
    case viewProfile = "View Profile"
    case onLogout = "Logout"
}

extension SupplierMenu {
    
    static func fromChoice(_ choice: Int) -> SupplierMenu? {
        let index = choice - 1
        
        if index >= 0 && index < allCases.count {
            return allCases[index]
        }
        return nil
    }
}
