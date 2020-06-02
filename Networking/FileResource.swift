import Foundation

public struct FileResource {
    public let name: String
    public let bundle: Bundle

    public init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

    public func load() -> Data {
        let components = name.components(separatedBy: ".")
        guard let fileName = components.first, let fileExt = components.last else {
            assertionFailure("invalid fileName: \(self)")
            return Data()
        }
        guard let url = bundle.url(forResource: fileName, withExtension: fileExt) else {
            assertionFailure("missing resource url")
            return Data()
        }
        guard let data = try? Data(contentsOf: url) else {
            assertionFailure("missing resource data")
            return Data()
        }
        return data
    }
}

public extension FileResource {
    static var none: FileResource {
        class Dummy {}
        return FileResource(name: "", bundle: Bundle(for: Dummy.self))
    }
}
