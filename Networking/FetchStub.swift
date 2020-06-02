import Foundation

public struct FetchStub: NetworkStub {
    public let url: URL
    public let statusCode: Int
    public let error: Error?
    public let delay: TimeInterval
    public let resource: FileResource

    // providing an error, or invalid status code, will ignore the resource
    // to use the resource, provide a valid status code, and no error
    public init(url: URL, statusCode: Int = 200, error: Error? = nil, delay: TimeInterval = 0,
                resource: FileResource? = nil) {
        self.url = url
        self.statusCode = statusCode
        self.error = error
        self.delay = delay
        self.resource = resource ?? .none
    }
}
