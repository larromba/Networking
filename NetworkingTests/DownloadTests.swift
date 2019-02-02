import AsyncAwait
@testable import Networking
import XCTest

final class DownloadTests: XCTestCase {
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
        fileManager = nil
        networkManager = nil
        super.tearDown()
    }

    func testSystemError() {
        // mocks
        urlSession.error = MockError.error
        do {
            // sut
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
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
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
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
        urlSession.downloadURL = nil
        do {
            // sut
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
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
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
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
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
        } catch {
            // test
            guard case NetworkError.httpErrorCode(403) = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testMoveError() {
        // mocks
        fileManager.actions.set(error: MockError.error, for: MockFileManager.moveItem2.name)
        do {
            // sut
            _ = try await(networkManager.download(.mock, option: .move(folder: .mockFolder)))
        } catch {
            // test
            guard case MockError.error = error else {
                XCTFail("expected error")
                return
            }
        }
    }

    func testMoveFolderOptions() {
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
