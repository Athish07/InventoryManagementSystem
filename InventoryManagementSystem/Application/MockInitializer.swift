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
        var user = User(
            userId: userRepository.getNextUserId(),
            name: "Athish",
            email: "athish@gmail.com",
            password: "athish",
            phoneNumber: "8148847642",
            customerProfile: nil,
            supplierProfile: nil
        )
        
        user.supplierProfile = Supplier(
            companyName: "Zoho",
            businessAddress: "Chennai"
        )
        
        user.customerProfile = Customer(
            shippingAddress: "Chennai"
        )
        
        userRepository.saveUser(user)
        
        let product = Product(
            productId: productRepository.getNextProductId(),
            name: "iphone 15",
            supplierId: user.userId,
            unitPrice: 1000,
            quantityInStock: 10,
            category: ProductCategory.phone
        )
        
        productRepository.addProduct(product)
    }
    
   
}
