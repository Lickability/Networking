//
//  MockNetworkSession.swift
//  NetworkingTests
//
//  Created by Michael Liberatore on 5/9/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import Foundation
import Networking

/// A mocked version of `NetworkSession` to be used in tests. Allows specification of specific success or failure cases.
class MockNetworkSession: NetworkSession {
    private let result: Result<Data, Error>

    /// Creates a new `MockNetworkSession`.
    /// - Parameter result: The expected result of network requests performed by this mock.
    init(result: Result<Data, Error>) {
        self.result = result
    }

    // MARK: - NetworkSession

    func makeDataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionDataTask {
        return MockNetworkSessionDataTask { [weak self] in
            switch self?.result {
            case .success(let data):
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                completionHandler(data, response, nil)
            case .failure(let error):
                let response = HTTPURLResponse(url: request.url!, statusCode: 0, httpVersion: nil, headerFields: nil)
                completionHandler(nil, response, error)
            case .none:
                assertionFailure("`MockNetworkSession` went out of scope. Keep a reference to it for the duration of your tests.")
            }
        }
    }

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return URLSession.DataTaskPublisher(request: request, session: .shared) // not currently mocked.
    }
}

private class MockNetworkSessionDataTask: NetworkSessionDataTask {
    private let resumeClosure: () -> Void

    init(closure: @escaping () -> Void) {
        self.resumeClosure = closure
    }

    func resume() {
        resumeClosure()
    }
}
