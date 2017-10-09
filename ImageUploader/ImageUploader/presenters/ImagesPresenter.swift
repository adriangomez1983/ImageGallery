//
//  ImagesPresenter.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/6/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation

protocol ImagesView: class {
    func startLoading()
    func finishLoading()
    func setImages(_ images: [ImageViewData])
    func setEmptyImages()
    func showError(_ error: ImagesServiceError)
    func presentUploadController(_ uploadController: UploadViewController)
    func presentGallery(_ galleryController: ImageGalleryViewController)
}

class ImagesPresenter {
    private let imagesService: ImagesService
    weak private var imagesView: ImagesView?
    
    init(service: ImagesService) {
        imagesService = service
    }
    
    func attachView(_ view: ImagesView) {
        self.imagesView = view
    }
    
    func detachView() {
        imagesView = nil
    }
    
    func getImages() {
        imagesView?.startLoading()
        imagesService.getAll(onCompletion: { [weak self] images in
            if images.isEmpty {
                self?.imagesView?.setEmptyImages()
            } else {
                let imagesViewData: [ImageViewData] = images.map {
                    ImageViewData(url: $0.url, fileName: $0.displayName)
                }
                self?.imagesView?.setImages(imagesViewData)
            }
            self?.imagesView?.finishLoading()
        }) { [weak self] error in
            self?.imagesView?.finishLoading()
            self?.imagesView?.showError(error)
        }
    }
    
    func presentUploadController() {
        let uploadController = UploadViewController(nibName: "UploadViewController", bundle: nil)
        imagesView?.presentUploadController(uploadController)
    }
    
    func presentGallery(_ selectedIndex: Int, withImages images: [ImageViewData]) {
        let galleryImages = images.map { ImageGalleryViewData(url: $0.url, description: $0.fileName) }
        let galleryController = ImageGalleryViewController(aPresenter: ImageGalleryPresenter(images: galleryImages, index: selectedIndex))
        imagesView?.presentGallery(galleryController)
    }
}
