import AsyncAwait
@testable import Networking
import TestExtensions
import XCTest

final class TestNetworkManagerTests: XCTestCase {
    // MARK: - fetch

    func test_fetchStub_whenGivenJsonFile_expectJson() {
        // mock
        let stub = FetchStub(url: .mock, resource: FileResource(name: "mock-fetch.json", bundle: .mock))
        let networkManager = TestNetworkManager(fetchStubs: [stub])

        // sut
        let response: MockResponse? = try? await(networkManager.fetch(request: MockRequest()))

        // test
        XCTAssertEqual(response?.json["name"] as? String, "test")
        XCTAssertEqual(response?.json["number"] as? Int, 90)
    }

    func test_fetchStub_whenUnauthorized_expectHTTPErrorCode403Error() {
        // mock
        let stub = FetchStub(url: .mock, statusCode: 403)
        let networkManager = TestNetworkManager(fetchStubs: [stub])
        // sut
        let closure = {
            let _: MockResponse? = try await(networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetchStub_whenGivenError_expectSystemError() {
        // mock
        let stub = FetchStub(url: .mock, error: MockError.error)
        let networkManager = TestNetworkManager(fetchStubs: [stub])
        // sut
        let closure = {
            let _: MockResponse? = try await(networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetchStub_whenGivenDelay_expectDelay() {
        // mock
        let delay = 1.0
        let stub = FetchStub(url: .mock, statusCode: 403, delay: delay)
        let networkManager = TestNetworkManager(fetchStubs: [stub])
        waitAsync(for: delay + 0.5) { completion in
            // sut
            let startTime = Date()
            let _: MockResponse? = try? await(networkManager.fetch(request: MockRequest()))
            let endTime = Date()
            // test
            XCTAssertEqual(endTime.timeIntervalSince(startTime), delay, accuracy: 0.2)
            completion()
        }
    }

    // MARK: - download

    func test_downloadStub_whenGivenJsonFile_expectJson() {
        // mock
        let resource = DownloadResource(writeURL: .makeTempURL(), data: "test".data(using: .utf8)!)
        let stub = DownloadStub(url: .mock, resource: resource)
        let networkManager = TestNetworkManager(downloadStubs: [stub])
        // sut
        let url = try? await(networkManager.download(.mock, option: .move(folder: .mock)))
        // test
        XCTAssertEqual(url?.absoluteString, resource.writeURL.absoluteString)
    }

    func test_downloadStub_whenUnauthorized_expectHTTPErrorCode403Error() {
        // mock
        let stub = DownloadStub(url: .mock, statusCode: 403)
        let networkManager = TestNetworkManager(downloadStubs: [stub])
        // sut
        let closure = {
            _ = try await(networkManager.download(.mock, option: .move(folder: .mock)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_downloadStub_whenGivenError_expectSystemError() {
        // mock
        let stub = DownloadStub(url: .mock, error: MockError.error)
        let networkManager = TestNetworkManager(downloadStubs: [stub])
        // sut
        let closure = {
            _ = try await(networkManager.download(.mock, option: .move(folder: .mock)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_downloadStub_whenGivenDelay_expectDelay() {
        // mock
        let delay = 1.0
        let stub = DownloadStub(url: .mock, statusCode: 403, delay: delay)
        let networkManager = TestNetworkManager(downloadStubs: [stub])
        waitAsync(for: delay + 0.5) { completion in
            // sut
            let startTime = Date()
            _ = try? await(networkManager.download(.mock, option: .move(folder: .mock)))
            let endTime = Date()
            // test
            XCTAssertEqual(endTime.timeIntervalSince(startTime), delay, accuracy: 0.2)
            completion()
        }
    }
}

// MARK: - private

private extension MockResponse {
    var json: [String: Any] {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = jsonObject as? [String: Any] else {
                XCTFail("can't read json")
                return [:]
        }
        return json
    }
}
