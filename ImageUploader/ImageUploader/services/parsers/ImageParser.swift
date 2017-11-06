//
//  ImageParser.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/3/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Image: Parsable {
  init(json: JSON) {
    url = json["url"].url!
    displayName = json["displayName"].stringValue
    description = json["description"].string
    isMain = json["main"].boolValue
  }
}
