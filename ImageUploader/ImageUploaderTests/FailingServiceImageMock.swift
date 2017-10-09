//
//  FailingServiceImageMock.swift
//  ImageUploaderTests
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
@testable import ImageUploader

class FailingImagesServiceMock: ImagesService {
    var baseURL: String { return "a URL" }
    
    func upload(_ imageData: Data, imageName name: String, onCompletion completionHandler:(() -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        errorHandler?(ImagesServiceError(description: "Something bad happened", message: "error", code: 500))
        
    }
    
    func getAll(onCompletion completionHandler:(([Image]) -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        errorHandler?(ImagesServiceError(description: "Something bad happened", message: "error", code: 500))
    }
}
