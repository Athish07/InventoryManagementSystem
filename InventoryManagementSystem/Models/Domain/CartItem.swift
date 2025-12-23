struct CartItem {
    let productId: Int
    var quantity: Int
    let unitPrice: Double
    let productName: String
    
    var itemTotal: Double {
        Double(quantity) * unitPrice
    }
}
