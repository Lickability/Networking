//
//  ErrorInformation.swift
//  Networking
//
//  Created by Twig on 4/22/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import Foundation

/// A structure containing information about an error.
public struct ErrorInformation {
    
    /// An error.
    public let error: LocalizedError
    
    /// A flag that is associated with the request that generated the error.
    public let flag: Bool
    
    /// Initializes an `ErrorInformation` with the provided parameters.
    /// - Parameters:
    ///   - error: The error to initialize with.
    ///   - flag: The flag associated with the request that generated the error.
    public init(error: LocalizedError, flag: Bool) {
        self.error = error
        self.flag = flag
    }
}
