import Foundation

final class AppFactory {

    private let orderRepository = InMemoryOrderRepository()
    private let userRepository = InMemoryUserRepository()
    private let itemRepository = InMemoryOrderItemRepository()
    private let productRepository = InMemoryProductRepository()
    private let cartRepository = InMemoryCartRepository()
    
    private let orderService: OrderService
    private let authenticationService: AuthenticationService
    private let userService: UserService
    private let productService: ProductService
    private let appView = AppView()
    
    init()
    {
        self.orderService = OrderManager(
            cartRepository: cartRepository,
            orderRepository: orderRepository,
            orderItemRepository: itemRepository,
            productRepository: productRepository
        )
        self.authenticationService = AuthenticationManager(
            userRepository: userRepository
        )
        self.userService = UserManager(userRepository: userRepository)
        self.productService = ProductManager(
            productRepository: productRepository,
            userRepository: userRepository
        )
        
        let mockInitializer = MockInitializer(
            userRepository: userRepository,
            productRepository: productRepository
        )
        mockInitializer.initializeSampleData()
    }
    
    func createAppController() -> AppController {
        AppController(
            appView: appView,
            authenticationService: authenticationService,
            orderService: orderService,
            productService: productService,
            userService: userService,
            appFactory: self
        )
    }
    
    func makeCustomerController(customerId: Int,onLogout: @escaping () -> Void) -> CustomerController {
        CustomerController(
            view: appView,
            orderService: orderService,
            productService: productService,
            userService: userService,
            customerId: customerId,
            onLogout: onLogout
        )
    }

    func makeSupplierController(supplierId: Int,onLogout: @escaping () -> Void) -> SupplierController {
        SupplierController(
            view: appView,
            productService: productService,
            supplierId: supplierId,
            userService: userService,
            onLogout: onLogout
        )
    }
    
}

