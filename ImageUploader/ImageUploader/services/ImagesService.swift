//
//  ImagesService.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/6/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ImagesService {
    var baseURL: String { get }
    func upload(_ imageData: Data, imageName name: String, onCompletion completionHandler:(() -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?)
    func getAll(onCompletion completionHandler:(([Image]) -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?)
}

class DefaultImagesService: ImagesService {
    var baseURL: String {
        get {
            if let path = Bundle.main.path(forResource: "services", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, String> {
                return dict["baseURL"] ?? ""
            } else {
                return ""
            }
            
        }
    }
    private let networkManager: NetworkManager
    
    init(networkManager aNetworkManager: NetworkManager) {
        networkManager = aNetworkManager
    }
    
    func upload(_ imageData: Data, imageName name: String, onCompletion completionHandler: (() -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        
        networkManager.postMultipart("\(baseURL)/files", httpHeaders: nil, body: imageData, fileName: name, onCompletion: { _ in
            completionHandler?()
        }, onError: { error in
            errorHandler?(error as! ImagesServiceError)
        })
    }
    
    func getAll(onCompletion completionHandler:(([Image]) -> Void)?, onError errorHandler: ((ImagesServiceError) -> Void)?) {
        
        networkManager.get("\(baseURL)/files", httpHeaders: nil, onCompletion: { imagesData in
            guard let data = imagesData else { return }
            var result = [Image]()
            if let jsonArray = JSON(data).array {
                for image in jsonArray {
                    let img = Image(json: image)
                    result.append(img)
                }
            }
            completionHandler?(result)
        }, onError: { error in
            errorHandler?(error as! ImagesServiceError)
        })
    }
}
