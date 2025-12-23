struct AuthDTO {

    struct CustomerRegistration {
        let name: String
        let email: String
        let password: String
        let phoneNumber: String
        let shippingAddress: String
    }

    struct SupplierRegistration {
        let name: String
        let email: String
        let password: String
        let phoneNumber: String
        let companyName: String
        let businessAddress: String
    }
    
}
