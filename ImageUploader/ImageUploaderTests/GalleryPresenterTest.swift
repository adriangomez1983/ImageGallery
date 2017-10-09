//
//  GalleryPresenterTest.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import XCTest
@testable import ImageUploader

class ImageGalleryViewMock: ImageGalleryView {
    var nextEnabled = false
    var imageSet = false
    var prevEnabled = false
    var startLoadingCalled = false
    var finishLoadingCalled = false
    var hintEnabled = false
    var hintFadedOut = false
    
    func setImage(_ image: ImageGalleryViewData, onCompleted completion: (() -> Void)?) {
        imageSet = true
    }
    
    func enableNext() {
        nextEnabled = true
    }
    
    func enablePrev() {
        prevEnabled = true
    }
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func stopLoading() {
        finishLoadingCalled = true
    }
    
    func enableHint() {
        hintEnabled = true
    }
    
    func disableHint() {
        hintEnabled = false
    }
    
    func fadeOutHint() {
        hintFadedOut = true
    }
    
    func disableNext() {}
    func disablePrev() {}
    func dismiss() {}
}

class GalleryPresenterTest: XCTestCase {
    
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
    
    func testSingleImage() {
        let imageGalleryViewMock = ImageGalleryViewMock()
        let presenter = ImageGalleryPresenter(images: [ImageGalleryViewData(url: URL(string: "http://some.url.com")!, description: "a name to display")])

        presenter.attachView(imageGalleryViewMock)
        presenter.loadCurrentImage()

        XCTAssert(imageGalleryViewMock.imageSet)
        XCTAssertFalse(imageGalleryViewMock.hintEnabled)
        XCTAssertFalse(imageGalleryViewMock.prevEnabled)
        XCTAssertFalse(imageGalleryViewMock.nextEnabled)
    }
    
    func testMultipleImagesFirst() {
        let imageGalleryViewMock = ImageGalleryViewMock()
        let presenter = ImageGalleryPresenter(images: [ImageGalleryViewData(url: URL(string: "http://some.url1.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url2.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url3.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url4.com")!, description: "a name to display")])
        
        presenter.attachView(imageGalleryViewMock)
        presenter.loadNext()
        
        XCTAssert(imageGalleryViewMock.imageSet)
        XCTAssert(imageGalleryViewMock.hintEnabled)
        XCTAssert(imageGalleryViewMock.prevEnabled)
    }
    
    func testMultipleImagesMiddle() {
        let imageGalleryViewMock = ImageGalleryViewMock()
        let presenter = ImageGalleryPresenter(images: [ImageGalleryViewData(url: URL(string: "http://some.url1.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url2.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url3.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url4.com")!, description: "a name to display")], index: 2)
        
        presenter.attachView(imageGalleryViewMock)
        presenter.loadCurrentImage()
        
        XCTAssert(imageGalleryViewMock.imageSet)
        XCTAssert(imageGalleryViewMock.hintEnabled)
        XCTAssert(imageGalleryViewMock.prevEnabled)
        XCTAssert(imageGalleryViewMock.nextEnabled)
    }
    
    func testMultipleImagesEnd() {
        let imageGalleryViewMock = ImageGalleryViewMock()
        let presenter = ImageGalleryPresenter(images: [ImageGalleryViewData(url: URL(string: "http://some.url1.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url2.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url3.com")!, description: "a name to display"),
                                                       ImageGalleryViewData(url: URL(string: "http://some.url4.com")!, description: "a name to display")], index: 3)
        
        presenter.attachView(imageGalleryViewMock)
        presenter.loadCurrentImage()
        
        XCTAssert(imageGalleryViewMock.imageSet)
        XCTAssert(imageGalleryViewMock.hintEnabled)
        XCTAssert(imageGalleryViewMock.prevEnabled)
        XCTAssertFalse(imageGalleryViewMock.nextEnabled)
    }
    
    func testNoImages() {
        let imageGalleryViewMock = ImageGalleryViewMock()
        let presenter = ImageGalleryPresenter(images: [])
        
        presenter.attachView(imageGalleryViewMock)
        presenter.loadCurrentImage()
        
        XCTAssertFalse(imageGalleryViewMock.imageSet)
        XCTAssertFalse(imageGalleryViewMock.hintEnabled)
        XCTAssertFalse(imageGalleryViewMock.prevEnabled)
        XCTAssertFalse(imageGalleryViewMock.nextEnabled)
    }
}
