import Foundation

extension Bundle {
    static var mock: Bundle {
        class Dummy {}
        return Bundle(for: Dummy.self)
    }
}
