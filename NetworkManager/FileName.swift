import Foundation
import Log

typealias FileName = String

extension FileName {
    private class Dummy {}

    func load() -> Data {
        let components = self.components(separatedBy: ".")
        guard let fileName = components.first, let fileExt = components.last else {
            log_error("invalid fileName: \(self)")
            return Data()
        }
        guard let url = Bundle(for: Dummy.self).url(forResource: fileName, withExtension: fileExt) else {
            log_error("missing resource url")
            return Data()
        }
        guard let data = try? Data(contentsOf: url) else {
            log_error("missing resource data")
            return Data()
        }
        return data
    }
}
