//
//  NetworkManagerTests.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/17/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import XCTest
@testable import ImageUploader

class NetworkManagerTests: XCTestCase {
    
    var networkManager: DefaultNetworkManager!
    var imageService: DefaultImagesService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = DefaultNetworkManager()
        imageService = DefaultImagesService(networkManager: networkManager)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotReachableForUpload() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "EXPECTING ERROR - THE SERVER SHOULD NOT BE RUNNING")
        imageService.upload(Data(), imageName: "a_name", onCompletion: nil) { error in
            expect.fulfill()
        }
        wait(for: [expect], timeout: 4.0)
    }
    
    func testNotReachableForGet() {
        let expect = expectation(description: "EXPECTING ERROR - THE SERVER SHOULD NOT BE RUNNING")
        imageService.getAll(onCompletion: nil) { (error) in
            expect.fulfill()
        }
        wait(for: [expect], timeout: 4.0)
    }
}
