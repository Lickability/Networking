//
//  NetworkSessionDataTask.swift
//  NetworkingTests
//
//  Created by Michael Liberatore on 5/9/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import Foundation

/// Describes a network session task that can be performed. This protocol has a similar API to `URLSessionDataTask` for the purpose of mocking.
public protocol NetworkSessionDataTask: Sendable {
    
    /// Progress object which represents the task progress. It can be used for task progress tracking.
    ///
    /// - Note: This documentation is pulled directly from `URLSessionTask`.
    var progress: Progress { get }
    
    /// Resumes the task, if it is suspended.
    ///
    /// - Note: This documentation is pulled directly from `URLSessionTask`.
    func resume()
}

extension URLSessionDataTask: NetworkSessionDataTask { }
