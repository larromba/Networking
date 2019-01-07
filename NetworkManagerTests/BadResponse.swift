import Foundation
@testable import Networking

struct BadResponse: Response {
    let data: Data
    init(data: Data) throws {
        throw MockError.error
    }
}
