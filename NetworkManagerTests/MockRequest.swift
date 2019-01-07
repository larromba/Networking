import Foundation
@testable import Networking

struct MockRequest: Request {
    var url: URL = .mock
    var httpVerb: HTTPVerb = .GET
    var body: Data? = nil
    var headers: [String: String]? = nil
    var parameters: [String: String]? = nil
}
