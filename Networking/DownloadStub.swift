import Foundation

public struct DownloadStub {
    let url: URL
    let writeURL: URL
    let data: Data

    public init(url: URL, writeURL: URL, data: Data) {
        self.url = url
        self.writeURL = writeURL
        self.data = data
    }
}
