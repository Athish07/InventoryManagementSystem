struct CartItem {
    let productId: Int
    var quantity: Int
    let unitPrice: Double

    var itemTotal: Double {
        Double(quantity) * unitPrice
    }
}
