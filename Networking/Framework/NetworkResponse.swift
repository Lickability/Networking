//
//  NetworkResponse.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// A defined structure for a successful network response.
public struct NetworkResponse {
    
    /// The data contained in the response.
    public let data: Data?
    
    /// The `URLResponse` for the request that was made.
    public let response: URLResponse
}
