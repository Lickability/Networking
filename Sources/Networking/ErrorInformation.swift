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
}
