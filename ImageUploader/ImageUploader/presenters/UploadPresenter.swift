//
//  UploadPresenter.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import UIKit

protocol UploadView: class {
    func setPreviewImage(_ image: UIImage)
    func startLoading()
    func finishLoading()
    func showSuccess(_ message: String)
    func showError(_ error: ImagesServiceError)
    func presentImagePicker()
    func presentCamera()
    func presentActionSheet()
    func dismissImagePicker()
    func presentCropController(_ cropController: CropViewController)
}


class UploadPresenter: NSObject {
    private let imageService: ImagesService
    weak var uploadView: UploadView?
    
    init(service: ImagesService) {
        imageService = service
    }
    
    func attachView(_ view: UploadView) {
        uploadView = view
    }
    
    func detachView() {
        uploadView = nil
    }
    
    func uploadImage(_ image: UIImage?, description imageDescription: String?) {
        guard let imageToUpload = image else {
            uploadView?.finishLoading()
            uploadView?.showError(ImagesServiceError(description: "No Image to upload", message: "", code: 500))
            return
        }
        
        uploadView?.startLoading()
        if let imageData = UIImageJPEGRepresentation(imageToUpload, 0) {
            let name = "\(imageData.hashValue).png"
            imageService.upload(imageData, imageName: name, description: imageDescription, onCompletion: { [weak self] in
                self?.uploadView?.finishLoading()
                self?.uploadView?.showSuccess("Image successfully uploaded")
            }, onError: { [weak self] error in
                self?.uploadView?.finishLoading()
                self?.uploadView?.showError(error)
            })
            
        }
    }
    
    func presentImagePicker() {
        uploadView?.presentImagePicker()
    }
    
    func presentCameraView() {
        uploadView?.presentCamera()
    }
    
    func presentPictureSourceOptions() {
        uploadView?.presentActionSheet()
    }
    
    func rotate(_ image: UIImage?) {
        guard let img = image else { return }
        let rotatedImg = img.image(withRotation: .pi/2)
        uploadView?.setPreviewImage(rotatedImg)
    }
    
    func crop() {
        let imageToCrop = (uploadView as? UploadViewController)?.previewImageView.image
        let cropViewController = CropViewController(aDelegate: self, imageToCrop: imageToCrop)
        uploadView?.presentCropController(cropViewController)
    }
    
}

extension UploadPresenter: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadView?.setPreviewImage(selectedImage)
        }
        uploadView?.dismissImagePicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        uploadView?.dismissImagePicker()
    }
    
}

extension UploadPresenter: UINavigationControllerDelegate {
    
}

extension UploadPresenter: CropViewControllerDelegate {
    func didCrop(_ image: UIImage?) {
        guard let img = image else { return }
        uploadView?.setPreviewImage(img)
    }
}

extension UploadPresenter: UITextViewDelegate {
    
}
