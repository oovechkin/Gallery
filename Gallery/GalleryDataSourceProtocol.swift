//
//  GalleryDataSourceProtocol.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

protocol GalleryItem {
    var image: UIImage? { get }
}

protocol GalleryDataSourceProtocol {
    var count:Int { get }
    subscript(index: Int) -> GalleryItem { get }
}
