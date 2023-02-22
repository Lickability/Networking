//
//  NetworkRequestStateController.swift
//  Networking
//
//  Created by Twig on 8/30/22.
//  Copyright © 2022 Lickability. All rights reserved.
//

import Foundation
import Combine

/// A class responsible for representing the state and value of a network request being made.
public final class NetworkRequestStateController {
    
    /// The state of a network request's lifecycle.
    public enum NetworkRequestState {
        
        /// A request that has not yet been started.
        case notInProgress
        
        /// A request that has been started, but not completed.
        case inProgress
        
        /// A request that has been completed with an associated result.
        case completed(Result<NetworkResponse, NetworkError>)
        
        /// A `Bool` representing if a request is in progress.
        public var isInProgress: Bool {
            switch self {
            case .notInProgress, .completed:
                return false
            case .inProgress:
                return true
            }
        }
        
        /// The completed `LocalizedError`, if one exists.
        public var completedError: LocalizedError? {
            switch self {
            case .notInProgress, .inProgress:
                return nil
            case let .completed(result):
                switch result {
                case .success:
                    return nil
                case let .failure(networkError):
                    return networkError
                }
            }
        }
        
        /// The completed `NetworkResponse`, if one exists.
        public var completedResponse: NetworkResponse? {
            switch self {
            case .notInProgress, .inProgress:
                return nil
            case let .completed(result):
                switch result {
                case let .success(response):
                    return response
                case .failure:
                    return nil
                }
            }
        }
        
        /// A `Bool` indicating if the request has finished successfully.
        public var didSucceed: Bool {
            return completedResponse != nil
        }
        
        /// A `Bool` indicating if the request has finished with an error.
        public var didFail: Bool {
            return completedError != nil
        }
    }
    
    /// A `Publisher` that can be subscribed to in order to receive updates about the status of a request.
    public private(set) lazy var publisher: AnyPublisher<NetworkRequestState, Never> = {
        return requestStatePublisher.prepend(.notInProgress).eraseToAnyPublisher()
    }()
    
    private let requestPerformer: NetworkRequestPerformer
    private let requestStatePublisher = PassthroughSubject<NetworkRequestState, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the `NetworkRequestStateController` with the specified parameters.
    /// - Parameter requestPerformer: The `NetworkRequestPerformer` used to make requests.
    public init(requestPerformer: NetworkRequestPerformer) {
        self.requestPerformer = requestPerformer
    }
        
    /// Sends a request with the specified parameters.
    /// - Parameters:
    ///   - request: The request to send.
    ///   - requestBehaviors: Additional behaviors to append to the request.
    public func send(request: any NetworkRequest, requestBehaviors: [RequestBehavior] = []) {
        requestStatePublisher.send(.inProgress)
        
        requestPerformer.send(request, requestBehaviors: requestBehaviors)
            .mapAsResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [requestStatePublisher] result in
                requestStatePublisher.send(.completed(result))
            })
            .store(in: &cancellables)
    }
    
    /// Resets the state of the `requestStatePublisher` and cancels any in flight requests that may be ongoing. Cancellation is not guaranteed, and requests that are near completion may end up finishing, despite being cancelled.
    public func resetState() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        requestStatePublisher.send(.notInProgress)
    }
}
