//
//  ImagesPresenterTests.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import XCTest
@testable import ImageUploader

class ImagesViewMock: ImagesView {
    var imagesSet = false
    var emptyImagesShown = false
    var errorShown = false
    var startLoadingCalled = false
    var finishLoadingCalled = false
    
    func setImages(_ images: [ImageViewData]) {
        imagesSet = true
    }
    
    func setEmptyImages() {
        emptyImagesShown = true
    }
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func finishLoading() {
        finishLoadingCalled = true
    }
    
    func showError(_ error: ImagesServiceError) {
        errorShown = true
    }
    func presentUploadController(_ uploadController: UploadViewController) {}
    
    func presentGallery(_ galleryController: ImageGalleryViewController) {}
}


class ImagesPresenterTests: XCTestCase {
    
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
    
    func testImagesNotEmpty() {
        let imagesView = ImagesViewMock()
        let presenter = ImagesPresenter(service: nonEmptyServiceMock)
        presenter.attachView(imagesView)
        presenter.getImages()
     
        XCTAssert(imagesView.startLoadingCalled)
        XCTAssert(imagesView.finishLoadingCalled)
        XCTAssert(imagesView.imagesSet)
    }
    
    func testImagesEmpty() {
        let imagesView = ImagesViewMock()
        let presenter = ImagesPresenter(service: emptyServiceMock)
        presenter.attachView(imagesView)
        presenter.getImages()
        
        XCTAssert(imagesView.startLoadingCalled)
        XCTAssert(imagesView.finishLoadingCalled)
        XCTAssertFalse(imagesView.imagesSet)
        XCTAssert(imagesView.emptyImagesShown)
    }
    
    func testError() {
        let imagesView = ImagesViewMock()
        let presenter = ImagesPresenter(service: failindServiceMock)
        presenter.attachView(imagesView)
        presenter.getImages()
        
        XCTAssert(imagesView.startLoadingCalled)
        XCTAssert(imagesView.finishLoadingCalled)
        XCTAssert(imagesView.errorShown)
    }
}
