//
//  PhotoRequest.swift
//  Networking
//
//  Created by Twig on 6/3/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import Foundation

enum PhotoRequest: NetworkRequest {

    case photosList
    case photo(identifier: Int)

    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        return "/photos"
    }

    var queryParameters: [URLQueryItem] {
        switch self {
        case .photosList:
            return []
        case let .photo(identifier):
            return [URLQueryItem(name: "id", value: String(identifier))]
        }
    }
}
