import Foundation

struct MenuSelectionHelper {
    
    static func select<T>(
        userChoice: Int,
        options: [T]
    ) -> T? {
        
        let index = userChoice - 1
        guard index >= 0 , index < options.count else {
            return nil
        }
        return options[index]
    
    }
}
