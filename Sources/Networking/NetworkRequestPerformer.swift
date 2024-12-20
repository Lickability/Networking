//
//  NetworkRequestPerformer.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation
import Combine

/// A protocol that defines functions needed to perform requests.
public protocol NetworkRequestPerformer: Sendable {
    
    /// Performs the given request with the given behaviors.
    ///
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    ///   - completion: A completion closure that is called when the request has been completed.
    /// - Returns: The `NetworkSessionDataTask` used to send the request. The implementation must call `resume()` on the task before returning.
    @discardableResult func send(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior], completion: (@Sendable (Result<NetworkResponse, NetworkError>) -> Void)?) -> NetworkSessionDataTask

    /// Returns a publisher that can be subscribed to, that performs the given request with the given behaviors.
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - scheduler: The scheduler to receive the call on. The scheduler passed in must match the `@MainActor` requirement to avoid data races.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    /// - Returns: Returns a publisher that can be subscribed to, that performs the given request with the given behaviors.
    @MainActor
    @discardableResult func send(_ request: any NetworkRequest, scheduler: some Scheduler, requestBehaviors: [RequestBehavior]) -> AnyPublisher<NetworkResponse, NetworkError>
    
    /// Performs the given request with the given behaviors returning a `NetworkResponse` with async/await, or throwing an error if unsuccessful.
    ///
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    /// - Returns: A network response object.
    func send(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior]) async throws -> NetworkResponse
}
