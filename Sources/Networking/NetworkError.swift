//
//  NetworkError.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Possible errors encountered during networking.
public enum NetworkError: LocalizedError {
    
    // MARK: - NetworkError
    
    /// The network request completed but erroneously provided no response.
    case noResponse
    
    /// The response could not be decoded because no data was present.
    case noData
    
    /// An underlying decoding error occurred.
    /// - Parameter error: The error that occurred while decoding.
    case decodingError(_ error: Error)
        
    /// The request succeeded, but the HTTP status code did not fall within a range considered successful.
    /// - Parameters:
    ///   - statusCode: The status that was received.
    ///   - data: The response data that was received.
    case unsuccessfulStatusCode(statusCode: Int, data: Data?)
    
    /// A generic error received from the core networking library.
    /// - Parameter error: The error that was received.
    case underlyingNetworkingError(_ error: Error)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .noData, .noResponse, .decodingError, .underlyingNetworkingError:
            return NSLocalizedString("Network Error Occurred", comment: "The title of an error alert shown when there is no valid data or no response from the server.")
        case .unsuccessfulStatusCode:
            return NSLocalizedString("Server Error Occurred", comment: "The title of an error alert shown when there is an unexpected server response.")
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .noData:
            return NSLocalizedString("The server returned no data.", comment: "A failure reason for an error when no data is provided.")
        case .noResponse:
            return NSLocalizedString("The server could not be reached for a response.", comment: "A failure reason for an error when no response is provided.")
        case .decodingError:
            return NSLocalizedString("The server’s data was not able to be read.", comment: "A failure reason for an error during decoding.")
        case let .unsuccessfulStatusCode(statusCode, _):
            return String.localizedStringWithFormat(NSLocalizedString("The server responded with a %d status code.", comment: "A failure reason for an error when the server returns an unsuccessful status code."), statusCode)
        case let .underlyingNetworkingError(error):
            return String.localizedStringWithFormat(NSLocalizedString("An underlying error occurred: %@", comment: "A failure reason for an error when an underlying network error occurs."), error.localizedDescription)
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .noData, .noResponse, .unsuccessfulStatusCode, .underlyingNetworkingError:
            return NSLocalizedString("Retry", comment: "A recovery suggestion for network errors.")
        case .decodingError:
            return nil
        }
    }
}
