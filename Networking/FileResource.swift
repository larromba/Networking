import Foundation
import Log

public struct FileResource {
    public let name: String
    public let bundle: Bundle

    public init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

    func load() -> Data {
        let components = name.components(separatedBy: ".")
        guard let fileName = components.first, let fileExt = components.last else {
            log_error("invalid fileName: \(self)")
            return Data()
        }
        guard let url = bundle.url(forResource: fileName, withExtension: fileExt) else {
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
