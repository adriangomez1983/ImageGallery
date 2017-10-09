//
//  FilesTableViewCell.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/3/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit
import AlamofireImage

class FilesTableViewCell: UITableViewCell {
    public static let defaultHeight = CGFloat(120)
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var imageData: UILabel!
    
    func loadImage(_ url: URL) {
        imageThumb.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "imagePlaceholder"))
    }
}
