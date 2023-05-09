//
//  NetworkSession.swift
//  Networking
//
//  Created by Michael Liberatore on 5/9/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import Foundation
import Combine

/// Describes an object that coordinates a group of related, network data transfer tasks. This protocol has a similar API to `URLSession` for the purpose of mocking.
public protocol NetworkSession {

    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameters:
    ///   - request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
    ///   - completionHandler: The completion handler to call when the load request is complete. This handler is executed on the delegate queue.
    /// - Returns: The new session data task.
    ///
    /// - Note: This documentation is pulled directly from `URLSession`.
    func makeDataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionDataTask

    /// Returns a publisher that wraps a URL session data task for a given URL request.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter request: The URL request for which to create a data task.
    /// - Returns: A publisher that wraps a data task for the URL request.
    ///
    /// - Note: This documentation is pulled directly from `URLSession`.
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkSession {
    public func makeDataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

public protocol NetworkSessionDataTask {
    func resume()
}

extension URLSessionDataTask: NetworkSessionDataTask { }
