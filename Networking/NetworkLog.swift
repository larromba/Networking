import Foundation
import Log

public enum NetworkLog {
    public static var isEnabled = true

    static func log(_ value: String) {
        Log.log(value)
    }
}
