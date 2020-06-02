import Foundation

public struct DownloadResource {
    public let writeURL: URL // FileDownloadOption in test network client is ignored when using this
    public let data: Data

    public init(writeURL: URL, data: Data) {
        self.writeURL = writeURL
        self.data = data
    }
}

public extension DownloadResource {
    static var none: DownloadResource {
        class Dummy {}
        return DownloadResource(writeURL: URL(fileURLWithPath: ""), data: Data())
    }
}
