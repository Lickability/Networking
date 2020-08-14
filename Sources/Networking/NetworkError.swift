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
    case decodingError(Error)
    
    /// There was no strong reference kept to the `NetworkController`.
    case noStrongReferenceToNetworkController

    /// A generic error received from the core networking library.
    case underlyingNetworkingError(Error)
}
