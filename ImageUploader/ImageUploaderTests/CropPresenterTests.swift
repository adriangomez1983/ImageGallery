//
//  CropPresenterTests.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import XCTest

@testable import ImageUploader

class CropViewMock: CropView {
    var croppedImageSet = false
    func zoomingView() -> UIView {
        return UIView(frame: CGRect.zero)
    }
    
    func setImage(_ image: UIImage) {
        croppedImageSet = true
    }
    
    func cropArea() -> CGRect {
        return CGRect(x: 0, y: 0, width: 20, height: 20)
    }
}

class CropPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCrop() {
        let cropViewMock = CropViewMock()
        let presenter = CropPresenter()
        
        presenter.attachView(cropViewMock)
        
        presenter.crop(#imageLiteral(resourceName: "imagePlaceholder"))
        
        XCTAssert(cropViewMock.croppedImageSet)
    }
}
