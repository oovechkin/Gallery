//
//  SampleDataProvider.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

struct SampleItem: GalleryItem {
    
    var tag: String
    var name: String
    
    var title: String {
        return "\(tag): \(name)"
    }
    
    func getThumbnail(_ completion: @escaping (UIImage?) -> ()) {
        getImage(completion)
    }
    
    func getLargeImage(_ completion: @escaping (UIImage?) -> ()) {
        getImage(completion)
    }
    
    private func getImage(_ completion: @escaping (UIImage?) -> ()) {
        let image = UIImage(named: name)
        completion(image)
    }
}


class SampleDataSource: GalleryDataSource {
    // nop
}


class SampleDataProvider: GalleryDataProvider {
    
    override func searchPhotos(withQuery query: String, completion: @escaping (DataSource?)->()) {
        
        var subset: [Item] = []
        if query.isEmpty {
            subset = allItems
        } else {
            let queryLowercased = query.lowercased()
            let filtered = allItems.filter { (item) -> Bool in
                return item.tag.contains(queryLowercased)
            }
            subset = filtered
        }
        let dataSource = buildDataSource(items: subset)
        completion(dataSource)
    }
    
    private let allItems = [
        SampleItem(tag: "bird", name: "sample1"),
        SampleItem(tag: "dog", name: "sample2"),
        SampleItem(tag: "plant", name: "sample3"),
        SampleItem(tag: "girl", name: "sample4"),
        SampleItem(tag: "space", name: "sample5"),
        SampleItem(tag: "bird", name: "sample1"),
        SampleItem(tag: "dog", name: "sample2"),
        SampleItem(tag: "plant", name: "sample3"),
        SampleItem(tag: "girl", name: "sample4"),
        SampleItem(tag: "space", name: "sample5"),
        SampleItem(tag: "bird", name: "sample1"),
        SampleItem(tag: "dog", name: "sample2"),
        SampleItem(tag: "plant", name: "sample3"),
        SampleItem(tag: "girl", name: "sample4"),
        SampleItem(tag: "space", name: "sample5"),
        SampleItem(tag: "bird", name: "sample1"),
        SampleItem(tag: "dog", name: "sample2"),
        SampleItem(tag: "plant", name: "sample3"),
        SampleItem(tag: "girl", name: "sample4"),
        SampleItem(tag: "space", name: "sample5"),
        ]
}
