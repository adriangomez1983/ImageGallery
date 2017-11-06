//
//  ImagesViewController.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/3/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ImagesViewController: UIViewController {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private static let numberOfSections = 2
    
    private var viewData: ImageViewData?
    private let presenter = ImagesPresenter(service: DefaultImagesService(networkManager: DefaultNetworkManager()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureRefreshControl()
        configureTableView()
        configureNavigationBar()
        configurePresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getImages()
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshImages(_:)), for: .valueChanged)
    }
    
    @objc private func refreshImages(_ sender: Any) {
        presenter.getImages()
    }
    
    private func configureTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "FilesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profile")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureNavigationBar() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addAction() {
        presenter.presentUploadController()
    }
    
    private func configurePresenter() {
        presenter.attachView(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ProfileTableViewCell.defaultHeight
        } else {
            return FilesTableViewCell.defaultHeight
        }
    }
}

extension ImagesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ImagesViewController.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let images = viewData?.images, indexPath.section != 0 {
            presenter.presentGallery(indexPath.row, withImages: images)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewData = viewData else { return 0 }
        if section == 0 {
            return viewData.images.isEmpty ? 0 : 1
        } else {
            return viewData.images.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile") as? ProfileTableViewCell,
            let viewData = viewData {
            
            cell.setViewData(viewData.mainImage())
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FilesTableViewCell, let img = viewData?.images[indexPath.row] {
            cell.selectionStyle = .none
            cell.setViewData(img)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 {
            return []
        }
        
        let setAsMainAction = UITableViewRowAction(style: .normal, title: "set as main", handler: { [weak self] action, indexPath in
            
            self?.presenter.setBiggerImage(indexPath.row)
        })
        setAsMainAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { [weak self] action, indexPath in
            self?.presenter.deleteImage(indexPath.row)
        }
        
        return viewData?.mainImage().displayName == viewData?.images[indexPath.row].displayName ? [deleteAction] : [setAsMainAction, deleteAction]
    }
}

extension ImagesViewController: ImagesView {
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func setImages(_ images: ImageViewData) {
        emptyView.isHidden = true
        tableView.isHidden = false
        viewData = images
        tableView.reloadData()
    }
    
    func setEmptyImages() {
        emptyView.isHidden = false
        tableView.isHidden = true
    }
    
    func showError(_ error: ImagesServiceError) {
        let alertController = UIAlertController(title: error.message ?? "Error", message: error.description ?? "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func presentUploadController(_ uploadController: UploadViewController) {
        navigationController?.pushViewController(uploadController, animated: true)
    }
    
    func presentGallery(_ galleryController: ImageGalleryViewController) {
        galleryController.modalPresentationStyle = .overFullScreen
        present(galleryController, animated: true, completion: nil)
    }
}

extension ImagesViewController: FilesTableViewCellDelegate {
    func didTapFavorite(_ isFavorite: Bool, _ cell: FilesTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let images = viewData?.images {
            let image = images[indexPath.row]
            presenter.updateImageMetadata(isFavorite, image.isMain, image)
        }
    }
}

