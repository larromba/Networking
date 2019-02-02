import Foundation
@testable import Networking

struct MockRequest: Request {
    var url: URL = .mock
    var httpVerb: HTTPVerb = .GET
    var body: Data?
    var headers: [String: String]?
    var parameters: [String: String]?
}
