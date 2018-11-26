# NetworkManager [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![Open Source Love png1](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

| master  | dev |
| ------------- | ------------- |
| [![Build Status](https://travis-ci.com/larromba/NetworkManager.svg?branch=master)](https://travis-ci.com/larromba/NetworkManager) | [![Build Status](https://travis-ci.com/larromba/NetworkManager.svg?branch=dev)](https://travis-ci.com/larromba/NetworkManager) |

## About
A simple `NetworkManager` to manage making HTTP requests. Designed to be a dependency of your API service objects. Uses a custom Async / Await implementation.

## Installation

### Carthage

```
// Cartfile
github "larromba/NetworkManager" ~> 1.0
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

`TestNetworkManager` can be used to load mock json for your tests

`MockNetworkManager` is a dummy network instance for your tests

`NetworkLog.isEnabled = true` turns on network logging

## Licence
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

## Contact
larromba@gmail.com
