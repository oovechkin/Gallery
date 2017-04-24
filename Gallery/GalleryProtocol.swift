//
//  GalleryProtocol.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit


protocol GalleryItem {
    
    var title: String { get }
    func getThumbnail(_ completion: @escaping (UIImage?) -> ())
    func getLargeImage(_ completion: @escaping (UIImage?) -> ())
}


protocol GalleryDataSourceProtocol {
    
    typealias Item = GalleryItem
    
    var count:Int { get }
    subscript(index: Int) -> Item { get }
}


protocol GalleryDataProviderProtocol {
    
    typealias Item = GalleryItem
    typealias DataSource = GalleryDataSourceProtocol
    
    var defaultQuery: String { get }
    func searchPhotos(withQuery query: String, completion: @escaping (DataSource?)->())
}


class GalleryDataSource: GalleryDataSourceProtocol {
    
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    var count:Int {
        return items.count
    }
    
    subscript(index: Int) -> Item {
        return items[index]
    }
}


class GalleryDataProvider: GalleryDataProviderProtocol {
    
    var defaultQuery: String {
        return ""
    }
    
    func buildDataSource(items: [Item]) -> DataSource {
        return GalleryDataSource.init(items: items)
    }
    
    func searchPhotos(withQuery query: String, completion: @escaping (DataSource?)->()) {
        completion(nil)
    }
}

