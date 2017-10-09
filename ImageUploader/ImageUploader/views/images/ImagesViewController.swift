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
    
    var elems: [ImageViewData] = [ImageViewData]()
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
        return CGFloat(FilesTableViewCell.defaultHeight)
    }
}

extension ImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.presentGallery(indexPath.row, withImages: elems)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FilesTableViewCell {
            cell.selectionStyle = .none
            let img = elems[indexPath.row]
            cell.imageData.text = img.fileName
            cell.loadImage(img.url)
            return cell
        }
        return UITableViewCell()
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
    
    func setImages(_ images: [ImageViewData]) {
        emptyView.isHidden = true
        tableView.isHidden = false
        elems = images
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

