import AsyncAwait
@testable import Networking
import XCTest

final class FetchTests: XCTestCase {
    private var urlSession: TestURLSession!
    private var networkManager: NetworkManager!
    private var fileManager: MockFileManager!

    override func setUp() {
        super.setUp()
        urlSession = TestURLSession()
        fileManager = MockFileManager()
        networkManager = NetworkManager(urlSession: urlSession, fileManager: fileManager,
                                        queue: MockOperationQueue())
    }

    override func tearDown() {
        urlSession = nil
        networkManager = nil
        fileManager = nil
        super.tearDown()
    }

    // MARK: - fetch

    func test_fetch_whenInternalError_expectSystemError() {
        // mocks
        urlSession.error = MockError.error
        // sut
        let closure = {
            let _: MockResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetch_whenCancelled_expectCancelledError() {
        // mocks
        urlSession.error = NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil)
        // sut
        let closure = {
            let _: MockResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.cancelled = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetch_whenNoData_expectNoDataError() {
        // mocks
        urlSession.data = nil
        // sut
        let closure = {
            let _: MockResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.noData = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetch_whenNoResponse_expectHTTPCodeError() {
        // mocks
        urlSession.response = nil
        // sut
        let closure = {
            let _: MockResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(500) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetch_whenUnauthorized_expectHTTPCodeError() {
        // mocks
        urlSession.response = HTTPURLResponse(url: .mock, statusCode: 403, httpVersion: nil, headerFields: nil)
        // sut
        let closure = {
            let _: MockResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_fetch_whenUnexpectedResponse_expectBadResponseError() {
        // sut
        let closure = {
            let _: BadResponse = try await(self.networkManager.fetch(request: MockRequest()))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.badResponse(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    // MARK: - download

    func test_download_whenInternalError_expectSystemError() {
        // mocks
        urlSession.error = MockError.error
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenIsCancelled_expectCancelledError() {
        // mocks
        urlSession.error = NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil)
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.cancelled = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenNoDownloadURL_expectNoDataError() {
        // mocks
        urlSession.downloadURL = nil
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.noData = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenNoResponse_expectHTTPErrorCode500Error() {
        // mocks
        urlSession.response = nil
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(500) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenUnauthorized_expectHTTPErrorCode403Error() {
        // mocks
        urlSession.response = HTTPURLResponse(url: .mock, statusCode: 403, httpVersion: nil, headerFields: nil)
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenErrorMovingFile_expectSystemError() {
        // mocks
        fileManager.actions.set(error: MockError.error, for: MockFileManager.moveItem2.name)
        // sut
        let closure = {
            try await(self.networkManager.download(.mock, option: .move(folder: .mockFolder)))
        }
        // test
        XCTAssertThrowsError(try closure(), "expected error thrown", { error in
            guard case NetworkError.systemError(MockError.error) = error else {
                XCTFail("wrong error \(error)")
                return
            }
        })
    }

    func test_download_whenMovingFileWithOptions_expectMovedToCorrectFilePath() {
        // mocks
        fileManager.actions.set(returnValue: true, for: MockFileManager.moveItem2.name)
        do {
            // sut
            let url1 = try await(networkManager
                .download(.mock, option: .move(folder: .mockFolder)))
            let url2 = try await(networkManager
                .download(.mock, option: .moveReplaceName(folder: .mockFolder, newFileName: "test2.tmp")))
            let url3 = try await(networkManager
                .download(.mock, option: .moveReplaceExtension(folder: .mockFolder, newFileExtension: ".png")))
            let url4 = try await(networkManager
                .download(.mock, option: .replaceExtension(newFileExtension: ".png")))

            // test
            XCTAssertEqual(url1.absoluteString, "file:///var/test.tmp")
            XCTAssertEqual(url2.absoluteString, "file:///var/test2.tmp")
            XCTAssertEqual(url3.absoluteString, "file:///var/test.png")
            XCTAssertEqual(url4.absoluteString, "file:///temp/test.png")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
