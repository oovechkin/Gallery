//
//  GalleryDataSource.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

class SampleDataSource {

    struct Item: GalleryItem {
        
        var tag: String
        var name: String
        
        func asyncThumbnail(_ completion: @escaping (UIImage?) -> ()) {
            asyncImage (completion)
        }
        func asyncImage(_ completion: @escaping (UIImage?) -> ()) {
            let image = UIImage(named: name)
            completion(image)
        }
    }
    
    fileprivate let items = [
        Item(tag: "bird", name: "sample1"),
        Item(tag: "dog", name: "sample2"),
        Item(tag: "plant", name: "sample3"),
        Item(tag: "girl", name: "sample4"),
        Item(tag: "space", name: "sample5"),
        Item(tag: "bird", name: "sample1"),
        Item(tag: "dog", name: "sample2"),
        Item(tag: "plant", name: "sample3"),
        Item(tag: "girl", name: "sample4"),
        Item(tag: "space", name: "sample5"),
        Item(tag: "bird", name: "sample1"),
        Item(tag: "dog", name: "sample2"),
        Item(tag: "plant", name: "sample3"),
        Item(tag: "girl", name: "sample4"),
        Item(tag: "space", name: "sample5"),
        Item(tag: "bird", name: "sample1"),
        Item(tag: "dog", name: "sample2"),
        Item(tag: "plant", name: "sample3"),
        Item(tag: "girl", name: "sample4"),
        Item(tag: "space", name: "sample5"),
        ]
}


extension SampleDataSource: GalleryDataSourceProtocol {

    var count:Int {
        return items.count
    }
    
    subscript(index: Int) -> GalleryItem {
        return items[index]
    }
}
