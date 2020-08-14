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
public protocol NetworkRequestPerformer {
    
    /// Performs the given request with the given behaviors.
    ///
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    ///   - completion: A completion closure that is called when the request has been completed.
    /// - Returns: The `URLSessionDataTask` used to send the request. The implementation must call `resume()` on the task before returning.
    @discardableResult func send(_ request: NetworkRequest, requestBehaviors: [RequestBehavior], completion: ((Result<NetworkResponse, NetworkError>) -> Void)?) -> URLSessionDataTask

    /// Returns a publisher that can be subscribed to, that performs the given request with the given behaviors.
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    /// - Returns: Returns a publisher that can be subscribed to, that performs the given request with the given behaviors.
    @available(iOS 13.0, *)
    @discardableResult func send(_ request: NetworkRequest, requestBehaviors: [RequestBehavior]) -> AnyPublisher<NetworkResponse, NetworkError>
}
