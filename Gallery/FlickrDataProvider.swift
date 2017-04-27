//
//  FlickrDataProvider.swift
//  Gallery
//
//  Created by Олег Овечкин on 24/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation
import UIKit


struct FlickrItem: GalleryItem {
    
    var photo: FlickrPhoto
    
    var title: String {
        return photo.title
    }
    
    func getThumbnail(_ completion: @escaping (UIImage?) -> ()) {
        getImage(withSize: .small240, completion: completion)
    }
    
    func getLargeImage(_ completion: @escaping (UIImage?) -> ()) {
        getImage(withSize: .large1024, completion: completion)
    }
    
    private func getImage(withSize size: FlickrPhotoSize, completion: @escaping (UIImage?) -> ()) {
        
        FlickrService.getImage(withPhoto: photo, size: size, completion: { (image, result) in
            
            if let result = result, case FlickrService.Result.failed(let message) = result {
                
                // TODO: show alert message
                print("error: \(message))")
                completion(nil)
                
            } else {
                completion(image)
            }
        })
    }
}


class FlickrDataSource: GalleryDataSource {
    // nop
}


class FlickrDataProvider: GalleryDataProvider {
    
    override var defaultQuery: String {
        return "people"
    }
    
    override func searchPhotos(withQuery query: String, completion: @escaping (DataSource?)->()) {
        
        FlickrService.searchPhotos(withQuery: query.lowercased(), completion: { (photos, result) in
            
            if let result = result, case FlickrService.Result.failed(let message) = result {
                
                // TODO: show alert message
                print("error: \(message))")
                completion(nil)
                
            } else if let photos = photos {
                
                let items = photos.map({ (photo) -> Item in
                    return FlickrItem(photo: photo)
                })
                
                let dataSource = self.buildDataSource(items: items)
                completion(dataSource)
                
            } else {
                
                completion(nil)
            }
        })
        
    }
}
