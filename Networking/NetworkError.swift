import Foundation

enum NetworkError: Error {
    case noData
    case systemError(Error)
    case httpErrorCode(Int)
    case badResponse(Error)
    case cancelled
}
