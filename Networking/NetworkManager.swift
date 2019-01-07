import AsyncAwait
import Foundation
import Logging
import Result

// sourcery: name = NetworkManager
public protocol NetworkManaging: Mockable {
    func fetch<T: Response>(request: Request) -> Async<T>
    func download(_ url: URL, option: FileDownloadOption) -> Async<URL>
    func cancelAll()
}

public final class NetworkManager: NetworkManaging {
    private enum FileName: String {
        case tmp = ".tmp"
    }

    private let urlSession: URLSessioning
    private let fileManager: FileManaging
    private let queue: OperationQueable

    public init(urlSession: URLSessioning, fileManager: FileManaging, queue: OperationQueable) {
        self.urlSession = urlSession
        self.fileManager = fileManager
        self.queue = queue
    }

    public func fetch<T: Response>(request: Request) -> Async<T> {
        NetworkLog.info("fetching: \(request.httpVerb) \(request.url)")

        return Async { completion in
            let operation = NetworkOperation()
            operation.task = self.urlSession
                .dataTask(with: request.urlRequest) { [weak operation] data, response, error in
                    defer {
                        operation?.finish()
                    }
                    if let error = self.validate(error: error, response: response) {
                        NetworkLog.error(error.localizedDescription)
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else {
                        NetworkLog.error(NetworkError.noData)
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    do {
                        NetworkLog.info("fetched: \(request.httpVerb) ...\(request.url.lastPathComponent)")
                        let response = try T(data: data)
                        completion(.success(response))
                    } catch {
                        NetworkLog.error("could not fetch: \(request.httpVerb) ...\(request.url.lastPathComponent)")
                        completion(.failure(NetworkError.badResponse(error)))
                    }
                }
            self.queue.addOperation(operation)
        }
    }

    public func download(_ url: URL, option: FileDownloadOption) -> Async<URL> {
        NetworkLog.info("downloading: \(url)")

        return Async { completion in
            let operation = NetworkOperation()
            operation.task = self.urlSession.downloadTask(with: url) { [weak operation] tempURL, response, error in
                defer {
                    operation?.finish()
                }
                if let error = self.validate(error: error, response: response) {
                    NetworkLog.error(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                guard let tempURL = tempURL else {
                    NetworkLog.error(NetworkError.noData)
                    completion(.failure(NetworkError.noData))
                    return
                }
                // must rename / move file else it's removed
                // see https://developer.apple.com/documentation/foundation/urlsession/1411511-downloadtask
                NetworkLog.info("downloaded: ...\(url.lastPathComponent) temporarilly to: \(tempURL)")
                switch self.moveFile(at: tempURL, withOption: option) {
                case .success(let fileURL):
                    NetworkLog.info("moved: ...\(url.lastPathComponent) finally to: \(fileURL)")
                    completion(.success(fileURL))
                case .failure(let error):
                    NetworkLog.error("could not move file \(url.lastPathComponent): \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            self.queue.addOperation(operation)
        }
    }

    public func cancelAll() {
        queue.cancelAllOperations()
    }

    // MARK: - private

    private func validate(error: Error?, response: URLResponse?) -> Error? {
        if let error = error {
            return error.isURLErrorCancelled ?
                NetworkError.cancelled : NetworkError.systemError(error)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.httpErrorCode(500)
        }
        guard httpResponse.statusCode.isValidRange else {
            return NetworkError.httpErrorCode(httpResponse.statusCode)
        }
        return nil
    }

    // swiftlint:disable pattern_matching_keywords
    private func moveFile(at fileURL: URL, withOption option: FileDownloadOption) -> Result<URL> {
        let newFileURL: URL
        switch option {
        case .move(let folderURL):
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(fileURL.lastPathComponent).path)
        case .moveReplaceName(let folderURL, let newFileName):
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(newFileName).path)
        case .moveReplaceExtension(let folderURL, let newFileExtension):
            let newFileName = fileURL.lastPathComponent
                .replacingOccurrences(of: FileName.tmp.rawValue, with: newFileExtension)
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(newFileName).path)
        case .replaceExtension(let newFileExtension):
            let newFileName = fileURL.path
                .replacingOccurrences(of: FileName.tmp.rawValue, with: newFileExtension)
            newFileURL = URL(fileURLWithPath: newFileName)
        }
        do {
            try self.fileManager.moveItem(at: fileURL, to: newFileURL)
            return .success(newFileURL)
        } catch {
            return .failure(error)
        }
    }
}
