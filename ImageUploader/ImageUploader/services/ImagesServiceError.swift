//
//  ServiceError.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ServiceError {
    var description: String?  { get }
    var message: String?  { get }
    var code: Int { get }
}

struct ImagesServiceError: ServiceError {
  var description: String?
  var message: String?
  var code: Int
}

extension ImagesServiceError: Parsable {
  init(json: JSON) {
    code = json["status"].intValue
    message = json["error"].string
    description = json["message"].string
  }
}
