final class MockInitializer {

    private let userRepository: UserRepository
    private let customerRepository: CustomerRepository
    private let supplierRepository: SupplierRepository
    private let productRepository: ProductRepository

    init(
        userRepository: UserRepository,
        customerRepository: CustomerRepository,
        supplierRepository: SupplierRepository,
        productRepository: ProductRepository

    ) {
        self.userRepository = userRepository
        self.customerRepository = customerRepository
        self.supplierRepository = supplierRepository
        self.productRepository = productRepository
    }

    func initializeSampleData() {

        let user = User(
            userId: userRepository.getNextUserId(),
            email: "athish@gmail.com",
            name: "Athish",
            password: "athish",
            phoneNumber: "8148847642"
        )

        userRepository.save(user)

        let supplier = Supplier(
            userId: user.userId,
            companyName: "Zoho",
            businessAddress: "Chennai"
        )

        supplierRepository.save(supplier)

        let customer = Customer(
            userId: user.userId,
            shippingAddress: "Chennai"
        )

        customerRepository.save(customer)

        let product1 = Product(
            productId: productRepository.getNextProductId(),
            name: "iPhone 15",
            supplierId: user.userId,
            unitPrice: 1000,
            quantityInStock: 10,
            category: .phone
        )
        let product2 = Product(
            productId: productRepository.getNextProductId(),
            name: "MacBook Pro m4",
            supplierId: user.userId,
            unitPrice: 10000,
            quantityInStock: 10,
            category: .laptop

        )

        productRepository.addProduct(product1)
        productRepository.addProduct(product2)

    }

}
