//
//  Parsable.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/3/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Parsable {
  init(json: JSON)
}
