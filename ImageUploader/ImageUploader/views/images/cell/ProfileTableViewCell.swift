//
//  ProfileTableViewCell.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/21/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    public static let defaultHeight = CGFloat(140)
    @IBOutlet weak var profileImage: UIImageView!
    
    func setViewData(_ viewData: Image) {
        profileImage.af_setImage(withURL: viewData.url)
    }
}
