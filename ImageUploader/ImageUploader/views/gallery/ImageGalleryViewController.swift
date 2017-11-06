//
//  ImageGalleryViewController.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class ImageGalleryViewController: UIViewController {
    @IBOutlet weak var imageDisplayNamelabel: UILabel!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var nextArrow: UIImageView!
    @IBOutlet weak var prevArrow: UIImageView!
    @IBOutlet weak var prevArea: UIView!
    @IBOutlet weak var nextArea: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    private let presenter: ImageGalleryPresenter
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    init(aPresenter: ImageGalleryPresenter) {
        presenter = aPresenter
        super.init(nibName: "ImageGalleryViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        presenter = ImageGalleryPresenter(images: [])
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadCurrentImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.hideHint()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        presenter.close()
    }
    @IBAction func nextAction(_ sender: Any) {
        presenter.loadNext()
    }
    
    @IBAction func prevAction(_ sender: Any) {
        presenter.loadPrev()
    }
}

extension ImageGalleryViewController: ImageGalleryView {
    func setImage(_ image: ImageGalleryViewData, onCompleted completion: (() -> Void)?) {
        imageView.af_setImage(withURL: image.url, placeholderImage: #imageLiteral(resourceName: "imagePlaceholder"), completion: { _ in
            completion?() })
        imageDisplayNamelabel.text = image.displayName
        imageDescriptionLabel.text = image.description ?? ""
    }

    func disableNext() {
        nextButton.isEnabled = false
    }

    func enableNext() {
        nextButton.isEnabled = true
    }

    func disablePrev() {
        prevButton.isEnabled = false
    }

    func enablePrev() {
        prevButton.isEnabled = true
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func fadeOutHint() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.nextArea.backgroundColor = .clear
            self?.nextArrow.alpha = CGFloat(0)
            self?.prevArea.backgroundColor = .clear
            self?.prevArrow.alpha = CGFloat(0)
        }
    }
    
    func enableHint() {
        nextArea.isHidden = false
//        nextArrow.isHidden = false
        prevArea.isHidden = false
//        prevArrow.isHidden = false
    }
    
    func disableHint() {
        nextArea.isHidden = true
//        nextArrow.isHidden = true
        prevArea.isHidden = true
//        prevArrow.isHidden = true
    }
}
