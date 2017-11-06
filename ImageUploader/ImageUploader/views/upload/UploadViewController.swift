//
//  UploadViewController.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/5/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit
import Alamofire

class UploadViewController: UIViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    private let actionSheet = UIAlertController(title: "Add picture", message: "From where do you want to get a picture", preferredStyle: .actionSheet)
    private let presenter = UploadPresenter(service: DefaultImagesService(networkManager: DefaultNetworkManager()))
    private let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarAddButton()
        configureDescriptionTextView()
        configureImagePicker()
        configureActionSheet()
        configurePreview()
        presenter.attachView(self)
    }
    
    private func configureDescriptionTextView() {
        descriptionTextView.text = ""
        descriptionTextView.delegate = presenter
    }
    
    private func configureActionSheet() {
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] action in
            self?.presenter.presentImagePicker()
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            self?.presenter.presentCameraView()
        })
        
        actionSheet.addAction(libraryAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraAction)
        }
    }
    
    private func configureNavigationBarAddButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc func addAction() {
        presenter.presentPictureSourceOptions()
    }
    
    private func configurePreview() {
        previewImageView.image = #imageLiteral(resourceName: "imagePlaceholder")
        uploadButton.isEnabled = false
        rotateButton.isEnabled = false
        cropButton.isEnabled = false
    }

    private func configureImagePicker() {
        imagePickerController.allowsEditing = false
        imagePickerController.modalPresentationStyle = .overCurrentContext
        imagePickerController.delegate = presenter
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        presenter.uploadImage(previewImageView.image, description: descriptionTextView.text)
    }
    
    @IBAction func rotateAction(_ sender: Any) {
        presenter.rotate(previewImageView.image)
    }
    
    @IBAction func cropAction(_ sender: Any) {
        presenter.crop()
    }
}

extension UploadViewController: UploadView {
    func setPreviewImage(_ image: UIImage) {
        previewImageView.image = image
        uploadButton.isEnabled = true
        rotateButton.isEnabled = true
        cropButton.isEnabled = true
        
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showSuccess(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showError(_ error: ImagesServiceError) {
        let alertController = UIAlertController(title: error.message ?? "Error", message: error.description ?? "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentCamera() {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentActionSheet() {
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func dismissImagePicker() {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func presentCropController(_ cropController: CropViewController) {
        self.navigationController?.pushViewController(cropController, animated: true)
    }
}
