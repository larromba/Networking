import AsyncAwait
import Foundation

open class TestNetworkManager: NetworkManaging {
    private let fetchStubs: [FetchStub]
    private let downloadStubs: [DownloadStub]

    public init(fetchStubs: [FetchStub] = [], downloadStubs: [DownloadStub] = []) {
        self.fetchStubs = fetchStubs
        self.downloadStubs = downloadStubs
        guard !fetchStubs.isEmpty || !downloadStubs.isEmpty else {
            assertionFailure("please provide some stubs")
            return
        }
    }

    open func fetch<T: Response>(request: Request) -> Async<T, NetworkError> {
        return Async { completion in
            async({
                let stub = try await(self.findAndProcessStub(in: self.fetchStubs, forURL: request.url))
                let response = try T(data: stub.resource.load())
                completion(.success(response))
            }, onError: { error in
                if let error = error as? NetworkError {
                    completion(.failure(error))
                } else {
                    assertionFailure(error.localizedDescription)
                    completion(.failure(.systemError(error)))
                }
            })
        }
    }

    open func download(_ url: URL, option: FileDownloadOption) -> Async<URL, NetworkError> {
        return Async { completion in
            async({
                let stub = try await(self.findAndProcessStub(in: self.downloadStubs, forURL: url))
                try stub.resource.data.write(to: stub.resource.writeURL)
                completion(.success(stub.resource.writeURL))
            }, onError: { error in
                if let error = error as? NetworkError {
                    completion(.failure(error))
                } else {
                    assertionFailure(error.localizedDescription)
                    completion(.failure(.systemError(error)))
                }
            })
        }
    }

    open func cancelAll() {}

    // MARK: - private

    private func findAndProcessStub<T: NetworkStub>(in stubs: [T]?, forURL url: URL) -> Async<T, NetworkError> {
        return Async { completion in
            guard let stub = stubs?.first(where: { $0.url == url }) else {
                assertionFailure("missing stub for url: \(url)")
                completion(.failure(.noData))
                return
            }
            if stub.delay > 0 {
                Thread.sleep(forTimeInterval: stub.delay)
            }
            if let error = stub.error {
                completion(.failure(error.isURLErrorCancelled ? .cancelled : .systemError(error)))
                return
            }
            if !stub.statusCode.isValidRange {
                completion(.failure(.httpErrorCode(stub.statusCode)))
                return
            }
            completion(.success(stub))
        }
    }
}
