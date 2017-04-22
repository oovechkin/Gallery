//
//  FlickrService.swift
//  Gallery
//
//  Created by Олег Овечкин on 22/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation
import Alamofire

class FlickrService {
    
    class URLBuilder {
    
        private static let base = "https://api.flickr.com/services/rest"
        private static let apiKey = "78de43f3fa99194cdf401536d9934362"
        private static let photosPerPage = 20
        
        private class func buildURL(_ method: String, params: Dictionary<String, String>) -> URL? {
        
            var query = ""
            let append = { (field: String, value: String) in
                let prefix = query.isEmpty ? "?" : "&"
                query += "\(prefix)\(field)=\(value)"
            }
            append("method", method)
            append("api_key", apiKey)
            append("format", "json")
            append("nojsoncallback", "1")
            
            for (field, value) in params {
                append(field, value)
            }
            guard let url = URL(string: base+query) else {
                return nil
            }
            return url
        }
        
        class func searchPhotos(withTag tag: String) -> URL? {
            
            guard let escapedTag = tag.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
                return nil
            }
            return buildURL("flickr.photos.search", params: [
                "text": escapedTag,
                "per_page": String(photosPerPage),
                ])
        }
        
        class func image(withId id: String, farm: String, server: String, secret: String) -> URL? {
            
            let string = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_s.jpg"
            guard let url = URL(string: string) else {
                return nil
            }
            return url
        }
    }
    
    class func searchPhotos(withTag tag: String, completion: @escaping (Any?)->()) {
     
        guard let url = URLBuilder.searchPhotos(withTag: tag) else {
            completion(nil)
            return
        }
        Alamofire.request(url).validate().responseJSON { response in
            guard let json = response.result.value else {
                completion(nil)
                return
            }
            completion(json)
        }
    }
}
