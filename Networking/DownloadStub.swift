import Foundation

public struct DownloadStub: NetworkStub {
    public let url: URL
    public let statusCode: Int
    public let error: Error?
    public let delay: TimeInterval
    public let resource: DownloadResource

    public init(url: URL, statusCode: Int = 200, error: Error? = nil, delay: TimeInterval = 0,
                resource: DownloadResource? = nil) {
        self.url = url
        self.statusCode = statusCode
        self.error = error
        self.delay = delay
        self.resource = resource ?? .none
    }
}
