import Foundation

extension Error {
    var isURLErrorCancelled: Bool {
        return (self as NSError).code == NSURLErrorCancelled
    }
}
