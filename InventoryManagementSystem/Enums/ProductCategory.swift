enum ProductCategory: String, CaseIterable {
    case phone = "Mobile Phone"
    case laptop = "Laptop"
    case accessory = "Accessory"
    case clothing = "Clothing"
    case other = "Other"
}

extension ProductCategory {
    
    static func fromChoice(_ choice: Int) -> ProductCategory? {
            let index = choice - 1
            guard index >= 0 && index < allCases.count else {
                return nil
            }
            return allCases[index]
        }
}

