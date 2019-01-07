import AsyncAwait
@testable import Networking
import XCTest

final class FetchTests: XCTestCase {
    private var urlSession: TestURLSession!
    private var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        urlSession = TestURLSession()
        networkManager = NetworkManager(urlSession: urlSession, fileManager: MockFileManager(),
                                        queue: MockOperationQueue())
    }

    override func tearDown() {
        urlSession = nil
        networkManager = nil
        super.tearDown()
    }

    func testSystemError() {
        // mocks
        urlSession.error = MockError.error
        do {
            // sut
            let _: MockResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testCancelledError() {
        // mocks
        urlSession.error = NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil)
        do {
            // sut
            let _: MockResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.cancelled = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testNoDataError() {
        // mocks
        urlSession.data = nil
        do {
            // sut
            let _: MockResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.noData = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testUnexpectedResponseError() {
        // mocks
        urlSession.response = nil
        do {
            // sut
            let _: MockResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.httpErrorCode(500) = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testResponseCodeError() {
        // mocks
        urlSession.response = HTTPURLResponse(url: .mock, statusCode: 403, httpVersion: nil, headerFields: nil)
        do {
            // sut
            let _: MockResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testBadResponse() {
        do {
            // sut
            let _: BadResponse = try await(networkManager.fetch(request: MockRequest()))
        } catch {
            // test
            guard case NetworkError.badResponse(MockError.error) = error else {
                XCTFail("expected error")
                return
            }
        }
    }
}
