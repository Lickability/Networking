//
//  HTTPMethod.swift
//  Networker
//
//  Created by Twig on 5/10/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Encapsulates HTTP methods for requests.
public enum HTTPMethod: String, Sendable {
    
    /// HTTP `GET`.
    case get = "GET"
    
    /// HTTP `POST`.
    case post = "POST"
    
    /// HTTP `PUT`.
    case put = "PUT"
    
    /// HTTP `DELETE`.
    case delete = "DELETE"
    
    /// HTTP `PATCH`.
    case patch = "PATCH"
}
