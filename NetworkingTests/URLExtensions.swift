import Foundation

extension URL {
    static var mock = URL(string: "http://google.com")!
    static var mockFolder = URL(string: "file:///var/")!
    static var mockFile = URL(string: "file:///temp/test.tmp")!

    static func makeTempURL() -> URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())\(UUID().uuidString)")
    }
}
