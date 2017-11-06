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
    
    func put(_ url: String,
             httpHeaders headers: HTTPHeaders?,
             body: [String: AnyObject]?,
             onCompletion completionHandler:((Any?) -> Void)?,
             onError errorHandler:((ServiceError) -> Void)?)
    
    func delete(_ url: String,
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
                        DefaultNetworkManager.validateServerResponse(uploadRequest, completionHandler: completionHandler, errorHandler: errorHandler)
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
                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            completionHandler?(value)
                        }
                        break
                    case .failure(let error):
                        let serviceError = ImagesServiceError(description: error.localizedDescription, message: nil, code: response.response?.statusCode ?? 500)
                        DispatchQueue.main.async {
                            errorHandler?(serviceError)
                        }
                        break
                    }
            }
        }
    }
    
    func delete(_ url: String, httpHeaders headers: HTTPHeaders?, onCompletion completionHandler: ((Any?) -> Void)?, onError errorHandler: ((ServiceError) -> Void)?) {
        DispatchQueue.global().async {
            Alamofire.request(url, method: .delete, headers: headers)
                .validate(statusCode: 200..<400)
                .response { response in
                    
                    if let error = response.error {
                        let serverError = ImagesServiceError(description: error.localizedDescription, message: nil, code: response.response?.statusCode ?? 500)
                        DispatchQueue.main.async {
                            errorHandler?(serverError)
                        }
                    } else {
                        completionHandler?(nil)
                    }
                }
        }
    }
    
    static func validateServerResponse(_ uploadRequest: UploadRequest, completionHandler: ((Any?) -> Void)?, errorHandler: ((ServiceError) -> Void)?) {
        uploadRequest.response(completionHandler: { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    errorHandler?(ImagesServiceError(description: error.localizedDescription, message: nil, code: 500))
                }
            } else if let status = response.response?.statusCode, status < 200 || status >= 400 {
                DispatchQueue.main.async {
                    errorHandler?(ImagesServiceError(description: "no error message - status code: \(status)", message: nil, code: status))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler?(nil)
                }
                
            }
        })
    }
    
    func put(_ url: String,
             httpHeaders headers: HTTPHeaders?,
             body: [String: AnyObject]?,
             onCompletion completionHandler:((Any?) -> Void)?,
             onError errorHandler:((ServiceError) -> Void)?) {
        
        DispatchQueue.global().async {
            let data = try! JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            Alamofire.request(request as URLRequestConvertible)
                .validate(statusCode: 200..<400)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            completionHandler?(value)
                        }
                        break
                    case .failure(let error):
                        let serviceError = ImagesServiceError(description: error.localizedDescription, message: nil, code: response.response?.statusCode ?? 500)
                        DispatchQueue.main.async {
                            errorHandler?(serviceError)
                        }
                        break
                    }
            }
        }
    }
}
