import AsyncAwait
import Foundation
import Result

open class TestNetworkManager: NetworkManaging {
    private let fetchStubs: [FetchStub]?
    private let downloadStubs: [DownloadStub]?

    public init(fetchStubs: [FetchStub]?, downloadStubs: [DownloadStub]?) {
        self.fetchStubs = fetchStubs
        self.downloadStubs = downloadStubs
    }

    open func fetch<T: Response>(request: Request) -> Async<T> {
        return Async { completion in
            switch self.getStub(from: self.fetchStubs, forURL: request.url) {
            case .success(let stub):
                do {
                    let response = try T(data: stub.resource.load())
                    completion(.success(response))
                } catch {
                    NetworkLog.error(error.localizedDescription)
                    completion(.failure(NetworkError.badResponse(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    open func download(_ url: URL, option: FileDownloadOption) -> Async<URL> {
        return Async { completion in
            switch self.getStub(from: self.downloadStubs, forURL: url) {
            case .success(let stub):
                do {
                    try stub.data.write(to: stub.writeURL)
                    completion(.success(stub.writeURL))
                } catch {
                    NetworkLog.error(error.localizedDescription)
                    completion(.failure(NetworkError.badResponse(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    open func cancelAll() {}

    // MARK: - private

    private func getStub<T: NetworkStub>(from stubs: [T]?, forURL url: URL) -> Result<T> {
        guard let stub = stubs?.first(where: { $0.url == url }) else {
            return .failure(NetworkError.noData)
        }
        if !stub.statusCode.isValidRange {
            return .failure(NetworkError.httpErrorCode(stub.statusCode))
        }
        if let error = stub.error {
            return .failure(error.isURLErrorCancelled ?
                NetworkError.cancelled : NetworkError.systemError(error)
            )
        }
        return .success(stub)
    }
}
