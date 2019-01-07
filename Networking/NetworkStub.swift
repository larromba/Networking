import Foundation

public protocol NetworkStub {
    var url: URL { get }
    var statusCode: Int { get }
    var error: Error? { get }
    var delay: Int { get }
}
