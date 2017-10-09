//
//  CropViewController.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit

protocol CropViewControllerDelegate: class {
    func didCrop(_ image: UIImage?)
}

class CropViewController: UIViewController, UIScrollViewDelegate {
    private let presenter = CropPresenter()
    
    weak var delegate: CropViewControllerDelegate?
    private let croppingImage: UIImage?
    @IBOutlet weak var cropAreaView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    init(aDelegate: CropViewControllerDelegate, imageToCrop: UIImage?) {
        delegate = aDelegate
        croppingImage = imageToCrop
        super.init(nibName: "CropViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        croppingImage = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureCropArea()
        configureNavigationBarAddButton()
        
        imageView.image = croppingImage
        presenter.attachView(self)
    }
    
    private func configureNavigationBarAddButton() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItems = [done]
    }
    
    @objc func doneAction() {
        presenter.crop(imageView.image)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    private func configureCropArea() {
        cropAreaView.layer.borderColor = UIColor.blue.cgColor
        cropAreaView.layer.borderWidth = 2
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension CropViewController: CropView {
    func zoomingView() -> UIView {
        return imageView
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
        scrollView.zoomScale = 1
        delegate?.didCrop(image)
    }
    
    func cropArea() -> CGRect {
        let factor = imageView.image!.size.width/view.frame.width
        let scale = 1/scrollView.zoomScale
        let imageFrame = imageView.imageFrame()
        let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
        let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
        let width = cropAreaView.frame.size.width * scale * factor
        let height = cropAreaView.frame.size.height * scale * factor
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
}
