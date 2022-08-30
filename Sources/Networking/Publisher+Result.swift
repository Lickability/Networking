//
//  Publisher+Result.swift
//  Networking
//
//  Created by Twig on 8/30/22.
//  Copyright © 2022 Lickability. All rights reserved.
//

import Foundation
import Combine

/// Adds extensions to the `Publisher` type to convert responses into `Result`s.
extension Publisher {
    
    /// Maps the chain of `Output`/`Failure` responses into a `Result` type that contains the `<Output/Failure>.
    /// - Returns: A `Publisher` that has converted the `Output` or `Failure` into a `Result`.
    public func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
