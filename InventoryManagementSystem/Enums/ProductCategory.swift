enum ProductCategory: String, CaseIterable {
    case phone = "Mobile Phone"
    case laptop = "Laptop"
    case accessory = "Accessory"
    case clothing = "Clothing"
    case other = "Other"
    
    static func fromChoice(_ choice: Int) -> ProductCategory? {
            let index = choice - 1
            guard index >= 0 && index < allCases.count else {
                return allCases[index]
            }
            return nil
        }
    
    static func fromChoiceOrDefault(_ choice: Int?) -> ProductCategory {
           guard
               let choice,
               let category = fromChoice(choice)
           else {
               return .other
           }
           return category
       }
    
}

