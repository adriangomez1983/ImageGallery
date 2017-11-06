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
    func setImages(_ images: ImageViewData)
    func setEmptyImages()
    func showError(_ error: ImagesServiceError)
    func presentUploadController(_ uploadController: UploadViewController)
    func presentGallery(_ galleryController: ImageGalleryViewController)
}

class ImagesPresenter {
    private let imagesService: ImagesService
    weak private var imagesView: ImagesView?
//    private let biggerImageIndexKey = "biggerImageIndex"
    private var imagesViewData: ImageViewData?
    
    init(service: ImagesService) {
        imagesService = service
//        UserDefaults.standard.set(0, forKey: biggerImageIndexKey)
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
            guard let `self` = self else { return }
            
            guard !images.isEmpty else {
                self.imagesView?.finishLoading()
                self.imagesView?.setEmptyImages()
                return
            }
//            let biggerImageName = self.getBiggerImageData()?.0 ?? images[0].displayName
            self.imagesViewData = ImageViewData(images: images)
            self.imagesView?.setImages(self.imagesViewData!)
            self.imagesView?.finishLoading()
        }) { [weak self] error in
            self?.imagesView?.finishLoading()
            self?.imagesView?.showError(error)
        }
    }
    
    func setBiggerImage(_ index: Int) {
        print("setting bigger image \(index)")
        
        //CALL THE SERVICE TO UPDATE THE BIGGER IMAGE
        
        
        
        
        
        
        
        
//        guard let biggerImage = imagesViewData?.images[index] else { return }
//
//        imagesService.updateImageMetadata(<#T##imageName: String##String#>, metadata: <#T##[String : String]#>, onCompletion: <#T##((Image) -> Void)?##((Image) -> Void)?##(Image) -> Void#>, onError: <#T##((ImagesServiceError) -> Void)?##((ImagesServiceError) -> Void)?##(ImagesServiceError) -> Void#>)
    }
//
//    func biggerImageIndex(forName name: String) -> Int {
//
//        if let biggerImageData = getBiggerImageData(), biggerImageData.0 == name {
//            return biggerImageData.1
//        } else {
//            return 0
//        }
//
//    }
//
//    private func getBiggerImageData() -> (String, Int)? {
//        if let biggerImageData = UserDefaults.standard.dictionary(forKey: biggerImageIndexKey),
//            let name = biggerImageData["name"] as? String,
//            let index = biggerImageData["index"] as? Int{
//            return (name, index)
//        }
//        return nil
//    }
    
    func presentUploadController() {
        let uploadController = UploadViewController(nibName: "UploadViewController", bundle: nil)
        imagesView?.presentUploadController(uploadController)
    }
    
    func deleteImage(_ index: Int) {
        imagesView?.startLoading()
        guard let imageToDelete = imagesViewData?.images[index] else {
            imagesView?.finishLoading()
            return
        }
        
        imagesService.deleteImage(imageToDelete.displayName,
                                  onCompletion: { [weak self] in
            self?.imagesView?.finishLoading()
//            if let biggerImageName = self?.getBiggerImageData()?.0, biggerImageName == imageToDelete.displayName {
//                self?.setBiggerImage(0)
//            }
            self?.getImages()
        }) { [weak self] error in
            self?.imagesView?.finishLoading()
            self?.imagesView?.showError(error)
        }
    }
    
    func presentGallery(_ selectedIndex: Int, withImages images: [Image]) {
        let galleryImages = images.map { ImageGalleryViewData(url: $0.url, displayName: $0.displayName, description: $0.description) }
        let galleryController = ImageGalleryViewController(aPresenter: ImageGalleryPresenter(images: galleryImages, index: selectedIndex))
        imagesView?.presentGallery(galleryController)
    }
    
    func updateImageMetadata(_ fav: Bool, _ isMain: Bool, _ img: Image) {
        let metadata = ["description" : img.displayName,
                        "favorite" : "\(fav)",
                        "main" : "\(isMain)"]
        imagesService.updateImageMetadata(img.displayName,
                                          metadata: metadata,
                                          onCompletion: { [weak self] image in
                                            self?.getImages()
            },
                                          onError: { [weak self] error in
                                            self?.imagesView?.showError(error)
        })
    }
}
