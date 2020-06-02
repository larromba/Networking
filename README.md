# Networking [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![Open Source Love png1](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

| master  | dev |
| ------------- | ------------- |
| [![Build Status](https://travis-ci.com/larromba/Networking.svg?branch=master)](https://travis-ci.com/larromba/Networking) | [![Build Status](https://travis-ci.com/larromba/Networking.svg?branch=dev)](https://travis-ci.com/larromba/Networking) |

## About
Simple networking code in Swift wrapping `URLSession` to manage making HTTP requests. Designed as a dependency to your API service objects. Uses a custom [async/await](https://github.com/larromba/asyncawait) implementation. 

## Installation

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

```
// Cartfile
github "larromba/Networking" ~> 2.0
```

```
// Terminal
carthage update
```

## Usage

Create a request struct implementing the `Request` protocol, and a response struct implementing the `Response` protocol.

```
struct MyResponse: Response {
    let data: Data
    let myObject: MyObject // this isn't in the protocol, but is a recommended pattern

    init(data: Data) throws {
        self.data = data
        myObject = // try to create object, else throw error
    }
}
```

You can then make the request as follows:

```swift

func doRequest() -> Async<MyObject, NetworkError> {
    return Async {
        async({
            let response: MyResponse = try await(networkManager.fetch(request: MyRequest))
            return .success(response.myObject)
        }, onError: { error in
            return .failure(error)
        )}
    }
}
```

`TestNetworkManager` can be injected into your app to load mock json:

```
final class MyNetworkStack {
    let networkManager: NetworkManaging // <-- must use NetworkManaging

    init(networkManager: NetworkManaging) { // <-- must use NetworkManaging
        self.networkManager = networkManager
    }
}

let testNetworkManager = TestNetworkManager(fetchStubs: [], downloadStubs: []) // <-- must provide at least one
let myNetworkingStack = MyNetworkStack(networkManager: testNetworkManager)

// Fetch stubs intercept fetch requests, to return your data (e.g. json)
let resource = FileResource(name: "my.json", bundle: .main)
let myFetchStub = FetchStub(url: urlToIntercept, resource: resource)
let testNetworkManager = TestNetworkManager(fetchStubs: [myFetchStub])

// Download stubs intercept download requests, and write your data (e.g. image) to a location
let resource = DownloadResource(writeURL: myDiskLocation, data: myImageData)
let myDownloadStub = DownloadStub(url: urlToIntercept, resource: resource)
let testNetworkManager = TestNetworkManager(downloadStubs: [myDownloadStub])

// Both stub types can be used to trigger errors, or status codes, for example:
_ = FetchStub(url: urlToIntercept, statusCode: 403)
_ = FetchStub(url: urlToIntercept, error: someError)
_ = DownloadStub(url: urlToIntercept, statusCode: 500)
_ = DownloadStub(url: urlToIntercept, error: someError)

// They also can simulate delays in seconds
_ = FetchStub(url: urlToIntercept, statusCode: 403,delay: 2)
_ = DownloadStub(url: urlToIntercept, statusCode: 403, delay: 2)
```

`NetworkLog.isEnabled = true` turns on network logging

## Licence
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

## Contact
larromba@gmail.com
