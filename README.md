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
github "larromba/Networking" ~> 1.0
```

```
// Terminal
carthage update
```

## Usage

Create a request struct implementing the `Request` protocol, and a response struct implementing the `Response` protocol.

You can then make the request as follows:

```swift

func doRequest() -> Async<MyObject> {
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

`TestNetworking` can be used to load mock json for your tests

`MockNetworking` is a dummy network instance for your tests

`NetworkLog.isEnabled = true` turns on network logging

## Licence
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

## Contact
larromba@gmail.com
