//
//  DetailsViewController.swift
//  Gallery
//
//  Created by Олег Овечкин on 22/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var item: GalleryItem? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    private class var identifier: String {
        return String(describing: self)
    }
    
    class func instance(withItem item: GalleryItem, storyboard: UIStoryboard?) -> UIViewController? {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        if let vc = vc as? DetailsViewController {
            vc.item = item
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        imageView.image = item?.image
    }
}
