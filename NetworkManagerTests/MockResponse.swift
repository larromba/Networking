import Foundation
@testable import Networking

struct MockResponse: Response {
    let data: Data
    init(data: Data) throws {
        self.data = data
    }
}
