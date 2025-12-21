struct ProductDTO {

    struct Create {
        let name: String
        let category: ProductCategory
        let unitPrice: Double
        let quantity: Int
    }

    struct Update {
        let productId: Int
        let name: String?
        let unitPrice: Double?
        let quantity: Int?
    }
}

