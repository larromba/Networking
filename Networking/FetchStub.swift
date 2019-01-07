import Foundation

public struct FetchStub: NetworkStub {
    public let url: URL
    public let statusCode: Int
    public let error: Error?
    public let delay: Int
    public let resource: FileResource

    public init(url: URL, statusCode: Int = 200, error: Error? = nil, delay: Int = 0, resource: FileResource) {
        self.url = url
        self.statusCode = statusCode
        self.error = error
        self.delay = delay
        self.resource = resource
    }
}
