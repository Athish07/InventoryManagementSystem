

import Foundation

struct AppFactory {
    
       func createAppController() -> AppController {
        
        let orderRepository = InMemoryOrderRepository()
        let userRepository = InMemoryUserRepository()
        let itemRepository = InMemoryOrderItemRepository()
        let productRepository = InMemoryProductRepository()
        let cartRepository = InMemoryCartRepository()
           
        
        let orderService = OrderManager(
            cartRepository: cartRepository,
            orderRepository: orderRepository,
            orderItemRepository: itemRepository,
            productRepository: productRepository,
        )
        let authenticationService = AuthenticationManager(
            userRepository: userRepository
        )
           
        let userService = UserManager(
            userRepository: userRepository
           )
        
        let productService = ProductManager(
            productRepository: productRepository,
            userRepository: userRepository
        )
        let appView = AppView()
            
            
        let controller = AppController(
            appView: appView,
            authenticationService: authenticationService,
            orderService: orderService,
            productService: productService,
            userService: userService
        )
           
        
        return controller
    }
}
