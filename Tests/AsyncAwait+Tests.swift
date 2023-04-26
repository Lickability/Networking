//
//  AsyncAwait+Tests.swift
//  NetworkingTests
//
//  Created by Ashli Rankin on 4/26/23.
//  Copyright © 2023 Lickability. All rights reserved.
//

import XCTest
@testable import Networking

final class AsyncAwait_Tests: XCTestCase {

    private let controller = NetworkController()
    
    func testSendMethod() async throws {
        do {
            let photos: [Photo] = try await controller.send(PhotoRequest.photosList)
            XCTAssertTrue(!photos.isEmpty)
        }
        catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
}
