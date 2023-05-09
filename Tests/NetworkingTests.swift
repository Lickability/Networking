//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Twig on 6/3/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkingTests: XCTestCase {

    func testExample() async throws {
        let networkController1 = NetworkController(networkSession: MockNetworkSession(result: .failure(NetworkError.noResponse)))

        do {
            let _: [Photo] = try await networkController1.send(PhotoRequest.photosList, requestBehaviors: [])
            XCTFail("Should’ve caught an error here.")
        }
        catch {
            print("error: \(error)")
        }

        let photos: [Photo] = [
            Photo(albumId: 1, id: 1, title: "1", url: "", thumbnailUrl: ""),
            Photo(albumId: 1, id: 2, title: "1", url: "", thumbnailUrl: ""),
            Photo(albumId: 1, id: 3, title: "1", url: "", thumbnailUrl: "")
        ]

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(photos)
            let networkController2 = NetworkController(networkSession: MockNetworkSession(result: .success(data)))
            let photosResponse: NetworkResponse = try await networkController2.send(PhotoRequest.photosList, requestBehaviors: [])
            let decodedData = photosResponse.data

            XCTAssertEqual(data, decodedData)
            //XCTAssertEqual(photos.map { $0.id }, [1, 2, 3])
        }
        catch {
            XCTFail("Unexpected error occurred: \(error).")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
