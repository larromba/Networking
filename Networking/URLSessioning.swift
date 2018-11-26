import Foundation

// sourcery: name = URLSession
public protocol URLSessioning: Mockable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func downloadTask(with url: URL,
                      completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
}
extension URLSession: URLSessioning {}
