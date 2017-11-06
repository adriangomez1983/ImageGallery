//
//  FilesTableViewCell.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/3/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit
import AlamofireImage

protocol FilesTableViewCellDelegate: class {
    func didTapFavorite(_ isFavorite: Bool, _ cell: FilesTableViewCell)
}

class FilesTableViewCell: UITableViewCell {
    public static let defaultHeight = CGFloat(120)
    
    weak var delegate: FilesTableViewCellDelegate?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var imageData: UILabel!

    private var isFavorited: Bool = false
    
    func setViewData(_ viewData: Image) {
        loadImage(viewData.url)
        imageData.text = viewData.displayName
        descriptionLabel.text = viewData.description
    }
    
    private func loadImage(_ url: URL) {
        imageThumb.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "imagePlaceholder"))
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        setFavorite(!isFavorited)
        delegate?.didTapFavorite(isFavorited, self)
    }
    
    func setFavorite(_ isFav: Bool) {
        UIView.animate(withDuration: 1) { [weak self] in
            isFav ? self?.favButton.setBackgroundImage(#imageLiteral(resourceName: "heartFilled"), for: .normal) : self?.favButton.setBackgroundImage(#imageLiteral(resourceName: "heartTransparent"), for: .normal)
        }
        isFavorited = isFav
    }
}
