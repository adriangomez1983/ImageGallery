//
//  UploadPresenterTests.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import XCTest
@testable import ImageUploader

class UploadViewMock: UploadView {
    var errorShown = false
    var successShown = false
    var loadingStarted = false
    var loadingFinished = false
    
    func startLoading() {
        loadingStarted = true
    }
    
    func finishLoading() {
        loadingFinished = true
    }
    
    func showSuccess(_ message: String) {
        successShown = true
    }
    
    func showError(_ error: ImagesServiceError) {
        errorShown = true
    }
    
    func setPreviewImage(_ image: UIImage) {}
    func presentImagePicker() {}
    func presentCamera() {}
    func presentActionSheet() {}
    func dismissImagePicker() {}
    func presentCropController(_ cropController: CropViewController) {}
}

class UploadPresenterTests: XCTestCase {
    
    let nonEmptyServiceMock = ImagesServiceMock(images: [Image(url: URL(string: "http://some.url.com")!, displayName: "a name to display"),
                                                         Image(url: URL(string: "http://someOther.url.com")!, displayName: "another name to display")])
    let emptyServiceMock = ImagesServiceMock(images: [])
    let failindServiceMock = FailingImagesServiceMock()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUploadSuccess() {
        let uploadView = UploadViewMock()
        let presenter = UploadPresenter(service: emptyServiceMock)
        
        presenter.attachView(uploadView)
        
        presenter.uploadImage(#imageLiteral(resourceName: "imagePlaceholder"))
        
        XCTAssert(uploadView.loadingStarted)
        XCTAssert(uploadView.loadingFinished)
        XCTAssert(uploadView.successShown)
    }
    
    func testUploadFailed() {
        let uploadView = UploadViewMock()
        let presenter = UploadPresenter(service: failindServiceMock)
        
        presenter.attachView(uploadView)
        
        presenter.uploadImage(#imageLiteral(resourceName: "imagePlaceholder"))
        
        XCTAssert(uploadView.loadingStarted)
        XCTAssert(uploadView.loadingFinished)
        XCTAssert(uploadView.errorShown)
    }
}
