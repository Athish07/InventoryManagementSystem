struct UserDTO {

    struct CustomerUpdate {
        let name: String?
        let email: String?
        let phoneNumber: String?
        let shippingAddress: String?
    }

    struct SupplierUpdate {
        let name: String?
        let email: String?
        let phoneNumber: String?
        let companyName: String?
        let businessAddress: String?
    }
}
