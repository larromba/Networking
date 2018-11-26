import Foundation

public struct FetchStub {
    public let url: URL
    public let resource: FileResource

    public init(url: URL, resource: FileResource) {
        self.url = url
        self.resource = resource
    }
}
