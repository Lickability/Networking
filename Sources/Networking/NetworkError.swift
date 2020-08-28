//
//  NetworkError.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// A list of possible errors encountered during networking.
public enum NetworkError: Error {
    
    /// The network request completed but erroneously provided no response.
    case noResponse
    
    /// The response could not be decoded because no data was present.
    case noData
    
    /// An underlying decoding error occurred.
    /// - Parameter error: The error that occurred while decoding.
    case decodingError(_ error: Error)
    
    /// There was no strong reference kept to the `NetworkController`.
    case noStrongReferenceToNetworkController
    
    /// The request succeeded, but the HTTP status code did not fall within a range considered successful.
    /// - Parameters:
    ///   - statusCode: The status that was received.
    ///   - data: The response data that was received.
    case unsuccessfulStatusCode(statusCode: Int, data: Data?)
    
    /// A generic error received from the core networking library.
    /// - Parameter error: The error that was received.
    case underlyingNetworkingError(_ error: Error)
}
