//
//  GalleryDataSourceProtocol.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

protocol GalleryItem {
    func asyncThumbnail(_ completion: @escaping (UIImage?) -> ())
    func asyncImage(_ completion: @escaping (UIImage?) -> ())
}

protocol GalleryDataSourceProtocol {
    var count:Int { get }
    subscript(index: Int) -> GalleryItem { get }
}
