//
//  CropPresenter.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/8/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit

protocol CropView: class {
    func zoomingView() -> UIView
    func setImage(_ image: UIImage)
    func cropArea() -> CGRect
}

class CropPresenter {
    private weak var cropView: CropView?
    
    func attachView(_ view: CropView) {
        cropView = view
    }
    
    func detachView() {
        cropView = nil
    }
    
    func crop(_ image: UIImage?) {
        guard let image = image?.cgImage, let view = cropView else { return }
        if let croppedCGImage = image.cropping(to: view.cropArea()) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
            view.setImage(croppedImage)
        }
        
    }
}
