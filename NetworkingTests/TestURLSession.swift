import Foundation
@testable import Networking

final class TestURLSession: URLSessioning {
    var downloadURL: URL? = .mockFile
    var data: Data? = Data()
    var response: URLResponse? = HTTPURLResponse(url: .mock, statusCode: 200, httpVersion: nil, headerFields: nil)
    var error: Error?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return URLSessionDataTask()
    }

    func downloadTask(with url: URL,
                      completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        completionHandler(downloadURL, response, error)
        return URLSessionDownloadTask()
    }
}
