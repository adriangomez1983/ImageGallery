//
//  ImageViewData.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation

struct ImageViewData {
    let images: [Image]
    
    func mainImage() -> Image {
        return images.filter { $0.isMain }.first!
    }
}
