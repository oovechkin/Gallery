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
    
    enum Error: Swift.Error {
        case success
        case failed(String)
    }
    
    class URLBuilder {
    
        private static let base = "https://api.flickr.com/services/rest"
        private static let apiKey = "78de43f3fa99194cdf401536d9934362"
        private static let photosPerPage = 20
        
        private class func buildURL(_ method: String, params: Dictionary<String, String>) throws -> URL {
        
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
                throw Error.failed("Fails to build an URL from string: \(base+query)")
            }
            return url
        }
        
        class func searchPhotos(withTag tag: String) throws -> URL {
            
            guard let escapedTag = tag.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
                throw Error.failed("Fails to apply percent encoding to tag: \(tag)")
            }
            return try buildURL("flickr.photos.search", params: [
                "text": escapedTag,
                "per_page": String(photosPerPage),
                ])
        }
        
        class func getImage(withId id: String, farm: String, server: String, secret: String) throws -> URL {
            
            let string = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_s.jpg"
            guard let url = URL(string: string) else {
                throw Error.failed("Fails to build an URL from string: \(string)")
            }
            return url
        }
    }
    
    typealias Completion = (Any?, Error?)->()
    
    class func searchPhotos(withTag tag: String, completion: @escaping Completion) {
     
        do {
            let url = try URLBuilder.searchPhotos(withTag: tag)
            Alamofire.request(url).validate().responseJSON { response in
                if let error = response.error {
                    completion(nil, Error.failed(error.localizedDescription))
                    return
                }
                guard let json = response.result.value else {
                    completion(nil, Error.failed("Failed to parse JSON from: \(response.result)"))
                    return
                }
                completion(json, nil)
            }
        } catch (let error as Error) {
            completion(nil, error)
        } catch {
            completion(nil, Error.failed("Unknown error"))
        }
    }
}
