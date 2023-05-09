//
//  MockNetworkSession.swift
//  NetworkingTests
//
//  Created by Michael Liberatore on 5/9/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import Foundation
import Networking

class MockNetworkSession: NetworkSession {

    private let result: Result<Data, Error>
    init(result: Result<Data, Error>) {
        self.result = result
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockSessionDataTask { [weak self] in
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

private class MockSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
