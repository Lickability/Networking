//
//  NetworkControllerTests.swift
//  NetworkingTests
//
//  Created by Michael Liberatore on 5/9/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkControllerTests: XCTestCase {

    func testAsyncAwaitSendWithFailure() async throws {
        let networkController = NetworkController(networkSession: MockNetworkSession(result: .failure(NetworkError.noResponse)))

        do {
            let _: [Photo] = try await networkController.send(PhotoRequest.photosList, requestBehaviors: [])
            XCTFail("Should’ve caught an error before reaching here.")
        }
        catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("Encountered an unexpected error type")
                return
            }

            switch networkError {
            case .decodingError, .noData, .noResponse, .unsuccessfulStatusCode:
                XCTFail("Encountered an unexpected NetworkError type")
            case .underlyingNetworkingError(let underlyingError):
                guard let underlyingNetworkError = underlyingError as? NetworkError else {
                    XCTFail("Encountered an unexpected underlying error type")
                    return
                }

                XCTAssertEqual(underlyingNetworkError.failureReason, NetworkError.noResponse.failureReason)
            }
        }
    }

    func testAsyncAwaitSendWithSuccess() async throws {
        let photos: [Photo] = [
            Photo(albumId: 1, id: 1, title: "1", url: "", thumbnailUrl: ""),
            Photo(albumId: 1, id: 2, title: "1", url: "", thumbnailUrl: ""),
            Photo(albumId: 1, id: 3, title: "1", url: "", thumbnailUrl: "")
        ]

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(photos)
            let networkController = NetworkController(networkSession: MockNetworkSession(result: .success(data)))
            let photosResponse: NetworkResponse = try await networkController.send(PhotoRequest.photosList, requestBehaviors: [])
            let decodedData = photosResponse.data

            XCTAssertEqual(data, decodedData)
        }
        catch {
            XCTFail("Unexpected error occurred: \(error).")
        }
    }

    func testAsyncAwaitBehaviors() async throws {
        let networkController = NetworkController(networkSession: MockNetworkSession(result: .failure(NetworkError.noResponse)))
        let expectation = expectation(description: "testAsyncAwaitBehaviors")
        
        let behavior = TestBehavior { willSend in
            XCTAssertTrue(willSend)
        } didFinishClosure: { didSend in
            XCTAssertTrue(didSend)
            expectation.fulfill()
        }
        
        do {
            let _: [Photo] = try await networkController.send(PhotoRequest.photosList, requestBehaviors: [behavior])
            XCTFail("Should’ve caught an error before reaching here.")
        } catch {
            if let networkError = error as? NetworkError {
                XCTAssertEqual(networkError.localizedDescription, NetworkError.noResponse.localizedDescription)
            } else {
                XCTFail("Expected to be able to cast error to NetworkError.")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
}

private struct TestBehavior: RequestBehavior {
    let willSendClosure: @Sendable (Bool) -> Void
    let didFinishClosure: @Sendable (Bool) -> Void

    func requestWillSend(request: inout URLRequest) {
        willSendClosure(true)
    }

    func requestDidFinish(result: Result<NetworkResponse, NetworkError>) {
        didFinishClosure(true)
    }
}
