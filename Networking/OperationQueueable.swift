import Foundation

// sourcery: name = OperationQueue
public protocol OperationQueable: Mockable {
    //swiftlint:disable identifier_name
    func addOperation(_ op: Operation)
    func cancelAllOperations()
}
extension OperationQueue: OperationQueable {}
