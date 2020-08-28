//
//  NetworkRequest.swift
//  Networker
//
//  Created by Twig on 5/10/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// A protocol that defines the parameters that make up a request.
public protocol NetworkRequest {
    
    /// The generated `URLRequest` to use for making network requests. Defaults to a url request built using the receiver’s properties.
    var urlRequest: URLRequest { get }
    
    /// The base `URL` without additional path or query components.
    var baseURL: URL { get }
    
    /// The path of the URL.
    var path: String { get }
    
    /// The HTTPMethod to use when making the request. Defaults to `get`.
    var httpMethod: HTTPMethod { get }
    
    /// A list of query parameters to add to the URL. Defaults to an empty array.
    var queryParameters: [URLQueryItem] { get }
    
    /// The HTTP header fields and their values to set on the request. Defaults to an empty dictionary.
    var httpHeaders: [String: String] { get }
    
    /// The data to send in the HTTPBody. Defaults to `nil`.
    var httpBody: Data? { get }
    
    /// HTTP status code ranges that should be considered successful. Defaults to 200 thru 299, inclusive.
    var successHTTPStatusCodes: HTTPStatusCodes { get }
}

/// Represents a collection of possible HTTP status codes.
public enum HTTPStatusCodes {
    
    /// All status codes.
    case all
    
    /// Status codes specified by a collection of ranges.
    case ranges([ClosedRange<Int>])
    
    /// Determines whether the specified status code is contained in the receiver.
    /// - Parameter statusCode: The status code to check.
    func contains(statusCode: Int) -> Bool {
        switch self {
        case .all:
            return true
        case let .ranges(ranges):
            return ranges.contains(where: { $0.contains(statusCode) })
        }
    }
}

public extension NetworkRequest {
    
    var urlRequest: URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path += path
        
        if !queryParameters.isEmpty {
            components?.queryItems = queryParameters
        }
        
        var urlRequest: URLRequest
        
        if let url = components?.url {
            urlRequest = URLRequest(url: url)
        } else {
            assertionFailure("The URLComponents failed to create a URL.")
            urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        }
        
        urlRequest.httpMethod = httpMethod.rawValue
        httpHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpBody = httpBody
        
        return urlRequest
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }

    var queryParameters: [URLQueryItem] {
        return []
    }
    
    var httpHeaders: [String: String] {
        return [:]
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var successHTTPStatusCodes: HTTPStatusCodes {
        return .ranges([200...299])
    }
}
