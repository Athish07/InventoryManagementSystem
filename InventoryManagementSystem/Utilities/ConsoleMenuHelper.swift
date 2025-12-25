import Foundation

struct ConsoleMenuHelper {

    static func select<T>(
        userChoice: Int,
        options: [T]
    ) -> T? {

        let index = userChoice - 1
        guard index >= 0, index < options.count else {
            return nil
        }

        return options[index]

    }

    static func readValidMenu<T>(
        show: () -> Void,
        read: () -> T?,
        onInvalid: () -> Void
    ) -> T {
        while true {
            show()
            if let value = read() {
                return value
            }
            onInvalid()
        }
    }
    
}
