//
//  MainNavigationViewController.swift
//  ImageUploader
//
//  Created by Néstor Adrián Gómez Elfi on 10/7/17.
//  Copyright © 2017 Néstor Adrián Gómez Elfi. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(rootViewController: ImagesViewController(nibName: "ImagesViewController", bundle: nil))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let _ = viewControllers.last as? CropViewController {
            return .portrait
        } else {
            return super.supportedInterfaceOrientations
        }
        
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let _ = viewControllers.last as? CropViewController {
            return .portrait
        } else {
            return super.preferredInterfaceOrientationForPresentation
        }
    }
}
