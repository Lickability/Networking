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
    ///   - completion: A completion closure that is called when the request has been completed.
    /// - Returns: The `URLSessionDataTask` used to send the request. The implementation must call `resume()` on the task before returning.
    public func send<ResponseType: Decodable>(_ request: NetworkRequest, requestBehaviors: [RequestBehavior] = [], completion: ((Result<ResponseType, NetworkError>) -> Void)? = nil) -> URLSessionDataTask {
        send(request, requestBehaviors: requestBehaviors) { result in
            switch result {
            case let .success(response):
         
                let decoder = JSONDecoder()
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
}
