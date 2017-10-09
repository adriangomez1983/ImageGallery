//
//  ImageGalleryPresenter.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation

protocol ImageGalleryView: class {
    func setImage(_ image: ImageGalleryViewData, onCompleted completion: (() -> Void)?)
    func disableNext()
    func enableNext()
    func disablePrev()
    func enablePrev()
    func startLoading()
    func stopLoading()
    func dismiss()
    func fadeOutHint()
    func enableHint()
    func disableHint()
}

class ImageGalleryPresenter {
    let galleryImages: [ImageGalleryViewData]
    private var currentIndex: Int
    weak var imageGalleryView: ImageGalleryView?
    
    init(images: [ImageGalleryViewData], index: Int = 0) {
        currentIndex = index
        galleryImages = images
    }
    
    func attachView(_ view: ImageGalleryView?) {
        imageGalleryView = view
        galleryImages.count <= 1 ? imageGalleryView?.disableHint() : imageGalleryView?.enableHint()
    }
    
    func detachView() {
        imageGalleryView = nil
    }
    
    private func loadImage(_ index: Int) {
        guard index >= 0 && index < galleryImages.count else { return }
        currentIndex = index
        imageGalleryView?.startLoading()
        imageGalleryView?.setImage(galleryImages[currentIndex],
                                   onCompleted: { [weak self] in
                                    self?.imageGalleryView?.stopLoading()
        })
        if index == galleryImages.count-1 {
            imageGalleryView?.disableNext()
        }
        if index == 0 {
            imageGalleryView?.disablePrev()
        }
        
        if index > 0 && index <= galleryImages.count-1 {
            imageGalleryView?.enablePrev()
        }
        
        if index >= 0 && index < galleryImages.count-1 {
            imageGalleryView?.enableNext()
        }
    }
    
    func loadCurrentImage() {
        loadImage(currentIndex)
    }
    
    func loadNext() {
        loadImage(currentIndex+1)
    }
    
    func loadPrev() {
        loadImage(currentIndex-1)
    }
    
    func close() {
        imageGalleryView?.dismiss()
    }
    
    func hideHint() {
        imageGalleryView?.fadeOutHint()
    }
}


