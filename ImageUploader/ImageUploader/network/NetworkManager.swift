//
//  NetworkManager.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/6/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkManager: class {
  
  func postMultipart(_ url: String,
            httpHeaders headers: HTTPHeaders?,
            body: Data,
            fileName: String,
            onCompletion completionHandler:((Any?) -> Void)?,
            onError errorHandler:((ServiceError) -> Void)?)
  
  func get(_ url: String,
            httpHeaders headers: HTTPHeaders?,
            onCompletion completionHandler:((Any?) -> Void)?,
            onError errorHandler:((ServiceError) -> Void)?)
}

class DefaultNetworkManager: NetworkManager {
    func postMultipart(_ url: String,
                       httpHeaders headers: HTTPHeaders?,
                       body: Data,
                       fileName: String,
                       onCompletion completionHandler: ((Any?) -> Void)?,
                       onError errorHandler: ((ServiceError) -> Void)?) {
        
        var finalHeaders: HTTPHeaders = ["encType" : "multipart/form-data"]
        if let userHeaders = headers {
            for (key, value) in userHeaders {
                finalHeaders[key] = value
            }
        }

        do {
            let urlRequest = try URLRequest(url: url, method: .post, headers: finalHeaders)
            DispatchQueue.global().async {
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(body, withName: "file", fileName: fileName, mimeType: "image/png")
                }, with: urlRequest, encodingCompletion: { result in
                    switch result {
                    case .success(let uploadRequest, _, _):
                        uploadRequest.responseString { response in
                            DispatchQueue.main.async {
                                completionHandler?(nil)
                            }
                        }
                        break
                    case .failure(let error):
                        let serviceError = ImagesServiceError(description: error.localizedDescription, message: nil, code: 400)
                        DispatchQueue.main.async {
                            errorHandler?(serviceError)
                        }
                        break
                    }
                })
            }
        } catch (let ex) {
            let serviceError = ImagesServiceError(description: ex.localizedDescription, message: nil, code: 500)
            DispatchQueue.main.async {
                errorHandler?(serviceError)
            }
        }
    }
    
    func get(_ url: String,
             httpHeaders headers: HTTPHeaders?,
             onCompletion completionHandler: ((Any?) -> Void)?,
             onError errorHandler: ((ServiceError) -> Void)?) {
            DispatchQueue.global().async {
                Alamofire.request(url, method: .get, headers: headers)
                    .validate(statusCode: 200..<400)
                    .responseJSON { response in
                        guard let httpResponseCode = response.response?.statusCode else { return }
                        switch response.result {
                        case .success(let value):
                            DispatchQueue.main.async {
                                completionHandler?(value)
                            }
                            break
                        case .failure(let error):
                            let serviceError = ImagesServiceError(description: error.localizedDescription, message: nil, code: httpResponseCode)
                            DispatchQueue.main.async {
                                errorHandler?(serviceError)
                            }
                            break
                        }
                }
            }
    }
}
