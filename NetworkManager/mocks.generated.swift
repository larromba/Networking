// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import AsyncAwait

// MARK: - Sourcery Helper

public protocol _StringRawRepresentable: RawRepresentable {
  var rawValue: String { get }
}

public struct _Variable<T> {
  let date = Date()
  var variable: T

  init(_ variable: T) {
    self.variable = variable
  }
}

public final class _Invocation {
  let name: String
  let date = Date()
  private var parameters: [String: Any] = [:]

  init(name: String) {
    self.name = name
  }

  fileprivate func set<T: _StringRawRepresentable>(parameter: Any, forKey key: T) {
    parameters[key.rawValue] = parameter
  }
  public func parameter<T: _StringRawRepresentable>(for key: T) -> Any? {
    return parameters[key.rawValue]
  }
}

public final class _Actions {
  enum Keys: String, _StringRawRepresentable {
    case returnValue
    case defaultReturnValue
    case error
  }
  private var invocations: [_Invocation] = []

  // MARK: - returnValue

  public func set<T: _StringRawRepresentable>(returnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.returnValue)
  }
  public func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
  }

  // MARK: - defaultReturnValue

  fileprivate func set<T: _StringRawRepresentable>(defaultReturnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
  }
  fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
  }

  // MARK: - error

  public func set<T: _StringRawRepresentable>(error: Error, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: error, forKey: Keys.error)
  }
  public func error<T: _StringRawRepresentable>(for functionName: T) -> Error? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.error) as? Error
  }

  // MARK: - private

  private func invocation<T: _StringRawRepresentable>(for name: T) -> _Invocation {
    if let invocation = invocations.filter({ $0.name == name.rawValue }).first {
      return invocation
    }
    let invocation = _Invocation(name: name.rawValue)
    invocations += [invocation]
    return invocation
  }
}

public final class _Invocations {
  private var history = [_Invocation]()

  fileprivate func record(_ invocation: _Invocation) {
    history += [invocation]
  }

  public func isInvoked<T: _StringRawRepresentable>(_ name: T) -> Bool {
    return history.contains(where: { $0.name == name.rawValue })
  }

  public func count<T: _StringRawRepresentable>(_ name: T) -> Int {
    return history.filter {  $0.name == name.rawValue }.count
  }

  public func all() -> [_Invocation] {
    return history.sorted { $0.date < $1.date }
  }

  public func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
    return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
  }
}

// MARK: - Sourcery Mocks

public class MockFileManager: NSObject, FileManaging {
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - removeItem

    public 
    func removeItem(at URL: URL) throws {
        let functionName = removeItem1.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: URL, forKey: removeItem1.params.URL)
        invocations.record(invocation)
    }

    public 
    enum removeItem1: String, _StringRawRepresentable {
      case name = "removeItem1"
      public enum params: String, _StringRawRepresentable {
        case URL = "removeItem(atURL:URL).URL"
      }
    }

    // MARK: - moveItem

    public 
    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        let functionName = moveItem2.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: srcURL, forKey: moveItem2.params.srcURL)
        invocation.set(parameter: dstURL, forKey: moveItem2.params.dstURL)
        invocations.record(invocation)
    }

    public 
    enum moveItem2: String, _StringRawRepresentable {
      case name = "moveItem2"
      public enum params: String, _StringRawRepresentable {
        case srcURL = "moveItem(atsrcURL:URL,todstURL:URL).srcURL"
        case dstURL = "moveItem(atsrcURL:URL,todstURL:URL).dstURL"
      }
    }

    // MARK: - createDirectory

    public 
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        let functionName = createDirectory3.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: createDirectory3.params.url)
        invocation.set(parameter: createIntermediates, forKey: createDirectory3.params.createIntermediates)
        if let attributes = attributes {
            invocation.set(parameter: attributes, forKey: createDirectory3.params.attributes)
        }
        invocations.record(invocation)
    }

    public 
    enum createDirectory3: String, _StringRawRepresentable {
      case name = "createDirectory3"
      public enum params: String, _StringRawRepresentable {
        case url = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).url"
        case createIntermediates = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).createIntermediates"
        case attributes = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).attributes"
      }
    }

    // MARK: - fileExists

    public 
    func fileExists(atPath path: String) -> Bool {
        let functionName = fileExists4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: path, forKey: fileExists4.params.path)
        invocations.record(invocation)
        actions.set(defaultReturnValue: true, for: functionName)
        return actions.returnValue(for: functionName) as! Bool
    }

    public 
    enum fileExists4: String, _StringRawRepresentable {
      case name = "fileExists4"
      public enum params: String, _StringRawRepresentable {
        case path = "fileExists(atPathpath:String).path"
      }
    }

    public init() {}
}

public class MockNetworkManager: NSObject, NetworkManaging {
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - fetch<T: Response>

    public 
    func fetch<T: Response>(request: Request) -> Async<T> {
        let functionName = fetch1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: request, forKey: fetch1.params.request)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<T>
    }

    public 
    enum fetch1: String, _StringRawRepresentable {
      case name = "fetch1"
      public enum params: String, _StringRawRepresentable {
        case request = "fetch<T:Response>(request:Request).request"
      }
    }

    // MARK: - download

    public 
    func download(_ url: URL, option: FileDownloadOption) -> Async<URL> {
        let functionName = download2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: download2.params.url)
        invocation.set(parameter: option, forKey: download2.params.option)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<URL>
    }

    public 
    enum download2: String, _StringRawRepresentable {
      case name = "download2"
      public enum params: String, _StringRawRepresentable {
        case url = "download(_url:URL,option:FileDownloadOption).url"
        case option = "download(_url:URL,option:FileDownloadOption).option"
      }
    }

    // MARK: - cancelAll

    public 
    func cancelAll() {
        let functionName = cancelAll3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    public 
    enum cancelAll3: String, _StringRawRepresentable {
      case name = "cancelAll3"
    }

    public init() {}
}

public class MockOperationQueue: NSObject, OperationQueable {
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - addOperation

    public 
    func addOperation(_ op: Operation) {
        let functionName = addOperation1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: op, forKey: addOperation1.params.op)
        invocations.record(invocation)
    }

    public 
    enum addOperation1: String, _StringRawRepresentable {
      case name = "addOperation1"
      public enum params: String, _StringRawRepresentable {
        case op = "addOperation(_op:Operation).op"
      }
    }

    // MARK: - cancelAllOperations

    public 
    func cancelAllOperations() {
        let functionName = cancelAllOperations2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    public 
    enum cancelAllOperations2: String, _StringRawRepresentable {
      case name = "cancelAllOperations2"
    }

    public init() {}
}

public class MockURLSession: NSObject, URLSessioning {
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - dataTask

    public 
    func dataTask(with request: URLRequest,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let functionName = dataTask1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: request, forKey: dataTask1.params.request)
        invocation.set(parameter: completionHandler, forKey: dataTask1.params.completionHandler)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! URLSessionDataTask
    }

    public 
    enum dataTask1: String, _StringRawRepresentable {
      case name = "dataTask1"
      public enum params: String, _StringRawRepresentable {
        case request = "dataTask(withrequest:URLRequest,completionHandler:@escaping(Data?,URLResponse?,Error?)->Void).request"
        case completionHandler = "dataTask(withrequest:URLRequest,completionHandler:@escaping(Data?,URLResponse?,Error?)->Void).completionHandler"
      }
    }

    // MARK: - downloadTask

    public 
    func downloadTask(with url: URL,completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let functionName = downloadTask2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: downloadTask2.params.url)
        invocation.set(parameter: completionHandler, forKey: downloadTask2.params.completionHandler)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! URLSessionDownloadTask
    }

    public 
    enum downloadTask2: String, _StringRawRepresentable {
      case name = "downloadTask2"
      public enum params: String, _StringRawRepresentable {
        case url = "downloadTask(withurl:URL,completionHandler:@escaping(URL?,URLResponse?,Error?)->Void).url"
        case completionHandler = "downloadTask(withurl:URL,completionHandler:@escaping(URL?,URLResponse?,Error?)->Void).completionHandler"
      }
    }

    public init() {}
}
