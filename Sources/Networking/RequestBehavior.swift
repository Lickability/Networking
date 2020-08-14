//
//  RequestBehavior.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// A protocol that can be used to implement behavior for requests being made.
public protocol RequestBehavior {
    
    /// A function that is called before a request is sent. You may modify the request at this time.
    ///
    /// - Parameter request: The request that will be sent.
    func requestWillSend(request: inout URLRequest)
    
    /// A function that is called when a request has been sent, and a response has been received.
    ///
    /// - Parameter result: The result from making the request.
    func requestDidFinish(result: Result<NetworkResponse, NetworkError>)
}

public extension RequestBehavior {
    func requestWillSend(request: inout URLRequest) { }
    func requestDidFinish(result: Result<NetworkResponse, NetworkError>) { }
}

extension Array: RequestBehavior where Element == RequestBehavior {
    public func requestWillSend(request: inout URLRequest) {
        forEach { $0.requestWillSend(request: &request) }
    }
    
    public func requestDidFinish(result: Result<NetworkResponse, NetworkError>) {
        forEach { $0.requestDidFinish(result: result) }
    }
}
