import Foundation

extension Data {
    var jsonString: String {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonStringData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let jsonString = String(data: jsonStringData, encoding: .utf8) else {
                return "<nil>"
        }
        return jsonString
    }
}
