import Foundation

public struct DownloadStub: NetworkStub {
    public let url: URL
    public let statusCode: Int
    public let error: Error?
    public let delay: Int
    public let writeURL: URL
    public let data: Data

    public init(url: URL, statusCode: Int = 200, error: Error? = nil, delay: Int = 0, writeURL: URL, data: Data) {
        self.url = url
        self.statusCode = statusCode
        self.error = error
        self.delay = delay
        self.writeURL = writeURL
        self.data = data
    }
}
