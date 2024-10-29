//
//  NetworkRequestPerformer+JSON.swift
//  Networking
//
//  Created by Michael Liberatore on 7/31/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import Foundation

extension NetworkRequestPerformer {
    
    /// Performs the given request with the given behaviors returning a JSON-decoded object via the completion handler.
    ///
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    ///   - decoder: The JSON decoder to use when decoding the data.
    ///   - completion: A completion closure that is called when the request has been completed.
    /// - Returns: The `NetworkSessionDataTask` used to send the request. The implementation must call `resume()` on the task before returning.
    @discardableResult public func send<ResponseType: Decodable>(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior] = [], decoder: JSONDecoder = JSONDecoder(), completion: (@Sendable (Result<ResponseType, NetworkError>) -> Void)? = nil) -> NetworkSessionDataTask {
        send(request, requestBehaviors: requestBehaviors) { result in
            switch result {
            case let .success(response):
                if let data = response.data {
                    do {
                        let decodedInstance = try decoder.decode(ResponseType.self, from: data)
                        completion?(.success(decodedInstance))
                    } catch {
                        completion?(.failure(.decodingError(error)))
                    }
                } else {
                    completion?(.failure(.noData))
                }
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    /// Performs the given request with the given behaviors returning a JSON-decoded object with async/await, or throwing an error if unsuccessful.
    ///
    /// - Parameters:
    ///   - request: The request to perform.
    ///   - requestBehaviors: The behaviors to apply to the given request.
    ///   - decoder: The JSON decoder to use when decoding the data.
    /// - Returns: A JSON-decoded object.
    public func send<ResponseType: Decodable>(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> ResponseType {
        let response = try await send(request, requestBehaviors: requestBehaviors)
        guard let data = response.data else {
            throw NetworkError.noData
        }
        do {
            return try decoder.decode(ResponseType.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
