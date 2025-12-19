final class MockInitializer {
    
    private let userRepository: UserRepository
    private let productRepository: ProductRepository
    
    init(
        userRepository: UserRepository,
        productRepository: ProductRepository
    ) {
        self.userRepository = userRepository
        self.productRepository = productRepository
    }
    
    func initializeSampleData()
    {
        let supplier = Supplier(
            userId: userRepository.getNextUserId(),
            name: "Athish",
            email: "athish@gmail.com",
            password: "athish",
            phoneNumber: "8148847642",
            companyName: "zoho",
            businessAddress: "chennai"
        )
        
        let customer = Customer(
            userId: userRepository.getNextUserId(),
            name: "Athish",
            email: "athish@gmail.com",
            password: "athish",
            phoneNumber: "8148847642",
            shippingAddress: "chennai"
        )
        
        let product = Product(
            productId: productRepository.getNextProductId(),
            name: "iphone 15",
            supplierId: supplier.userId,
            unitPrice: 1000,
            quantityInStock: 10,
            category: ProductCategory.phone
        )
        
        productRepository.addProduct(product)
        userRepository.saveUser(supplier)
        userRepository.saveUser(customer)
        
    }
    
   
}
