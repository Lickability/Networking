//
//  NetworkController.swift
//  Networker
//
//  Created by Twig on 5/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation
import Combine

/// A default concrete implementation of the `NetworkRequestPerformer`.
public final class NetworkController {

    private let urlSession: URLSession
    private let defaultRequestBehaviors: [RequestBehavior]

    /// Initializes the `NetworkController`.
    ///
    /// - Parameters:
    ///   - urlSession: The `URLSession` to use to make requests. Defaults to `URLSession.shared`.
    ///   - defaultRequestBehaviors: The request behaviors to apply to all requests made through this controller. Defaults to an empty array.
    public init(urlSession: URLSession = .shared, defaultRequestBehaviors: [RequestBehavior] = []) {
        self.urlSession = urlSession
        self.defaultRequestBehaviors = defaultRequestBehaviors
    }
    
    private func makeFinalizedRequest(fromOriginalRequest originalRequest: URLRequest, behaviors: [RequestBehavior]) -> URLRequest {
        var urlRequest = originalRequest

        behaviors.requestWillSend(request: &urlRequest)

        return urlRequest
    }

    private func makeDataTask(forURLRequest urlRequest: URLRequest, behaviors: [RequestBehavior] = [], successHTTPStatusCodes: HTTPStatusCodes, completion: ((Result<NetworkResponse, NetworkError>) -> Void)?) -> URLSessionDataTask {

        return urlSession.dataTask(with: urlRequest) { data, response, error in
            let result: Result<NetworkResponse, NetworkError>
            
            if let error = error {
                result = .failure(.underlyingNetworkingError(error))
            } else if let response = response {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, !successHTTPStatusCodes.contains(statusCode: statusCode)  {
                    result = .failure(.unsuccessfulStatusCode(statusCode: statusCode, data: data?.isEmpty == true ? nil : data))
                } else {
                    result = .success(NetworkResponse(data: data, response: response))
                }
            } else {
                result = .failure(.noResponse)
            }

            behaviors.requestDidFinish(result: result)

            completion?(result)
        }
    }
}

extension NetworkController: NetworkRequestPerformer {
    
    // MARK: - NetworkRequestPerformer
    
    @discardableResult public func send(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior] = [], completion: ((Result<NetworkResponse, NetworkError>) -> Void)? = nil) -> URLSessionDataTask {
        let behaviors = defaultRequestBehaviors + requestBehaviors

        let urlRequest = makeFinalizedRequest(fromOriginalRequest: request.urlRequest, behaviors: behaviors)
        let dataTask = makeDataTask(forURLRequest: urlRequest, successHTTPStatusCodes: request.successHTTPStatusCodes, completion: completion)

        dataTask.resume()

        return dataTask
    }

    @available(iOS 13.0, *)
    @discardableResult public func send(_ request: any NetworkRequest, requestBehaviors: [RequestBehavior] = []) -> AnyPublisher<NetworkResponse, NetworkError> {
        let behaviors = defaultRequestBehaviors + requestBehaviors
        let urlRequest = makeFinalizedRequest(fromOriginalRequest: request.urlRequest, behaviors: behaviors)
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapError { NetworkError.underlyingNetworkingError($0) }
            .tryMap { data, response in
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, !request.successHTTPStatusCodes.contains(statusCode: statusCode) {
                    throw NetworkError.unsuccessfulStatusCode(statusCode: statusCode, data: data.isEmpty ? nil : data)
                } else {
                    return NetworkResponse(data: data, response: response)
                }
            }
            .mapError { ($0 as? NetworkError) ?? .underlyingNetworkingError($0) }
            .handleEvents(receiveOutput: { response in
                behaviors.requestDidFinish(result: .success(response))
            }, receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    behaviors.requestDidFinish(result: .failure(error))
                }
            })
            .eraseToAnyPublisher()
    }
}
