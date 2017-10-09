//
//  ImagesServiceMock.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
@testable import ImageUploader

class ImagesServiceMock: ImagesService {
    var baseURL: String { return "a URL" }
    private let imgs: [Image]
    
    init(images: [Image]) {
        imgs = images
    }
    
    func upload(_ imageData: Data, imageName name: String, onCompletion completionHandler:(() -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        completionHandler?()
        
    }
    
    func getAll(onCompletion completionHandler:(([Image]) -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        completionHandler?(imgs)
    }
}
