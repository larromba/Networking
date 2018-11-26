import Foundation

public protocol Response {
    var data: Data { get }

    init(data: Data) throws
}
