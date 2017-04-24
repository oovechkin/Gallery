//
//  FlickrService.swift
//  Gallery
//
//  Created by Олег Овечкин on 22/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Unbox


struct FlickrPhoto {
    let farm: String
    let server: String
    let id: String
    let secret: String
    let title: String
}

extension FlickrPhoto: Unboxable {
    init(unboxer: Unboxer) throws {
        farm = try unboxer.unbox(key: "farm")
        server = try unboxer.unbox(key: "server")
        id = try unboxer.unbox(key: "id")
        secret = try unboxer.unbox(key: "secret")
        title = try unboxer.unbox(key: "title")
    }
}


fileprivate struct FlickPhotoContainer {
    let photos: [FlickrPhoto]
}

extension FlickPhotoContainer: Unboxable {
    init(unboxer: Unboxer) throws {
        photos = try unboxer.unbox(key: "photo")
    }
}


fileprivate struct FlickrResponse {
    let stat: String
    let message: String?
    let photoContainer: FlickPhotoContainer?
}


extension FlickrResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        stat = try unboxer.unbox(key: "stat")
        message = unboxer.unbox(key: "message")
        photoContainer = unboxer.unbox(key: "photos")
    }
}


enum FlickrPhotoSize: String {
    // s	small square 75x75
    case smallSquare = "s"
    // q	large square 150x150
    case largeSquare = "q"
    // t	thumbnail, 100 on longest side
    case thumbnail = "t"
    // m	small, 240 on longest side
    case small240 = "m"
    // n	small, 320 on longest side
    case small320 = "n"
    // -	medium, 500 on longest side
    case medium500 = "-"
    // z	medium 640, 640 on longest side
    case medium640 = "z"
    // c	medium 800, 800 on longest side†
    case medium800 = "c"
    // b	large, 1024 on longest side*
    case large1024 = "b"
    // h	large 1600, 1600 on longest side†
    case large1600 = "h"
    // k	large 2048, 2048 on longest side†
    case large2048 = "k"
    // o	original image, either a jpg, gif or png, depending on source format
    case original = "o"
}


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
        
        class func searchPhotos(withQuery query: String) throws -> URL {
            
            guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
                throw Error.failed("Fails to apply percent encoding to query: \(query)")
            }
            return try buildURL("flickr.photos.search", params: [
                "text": escapedQuery,
                "per_page": String(photosPerPage),
                ])
        }
        
        class func getImage(withSize size: FlickrPhotoSize, id: String, farm: String, server: String, secret: String) throws -> URL {
            
            let extention = "jpg"
            let string = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).\(extention)"
            guard let url = URL(string: string) else {
                throw Error.failed("Fails to build an URL from string: \(string)")
            }
            return url
        }
    }
}


extension FlickrService {
    
    typealias SearchCompletion = ([FlickrPhoto]?, Error?)->()
    
    class func searchPhotos(withQuery query: String, completion: @escaping SearchCompletion) {
        
        do {
            let url = try URLBuilder.searchPhotos(withQuery: query)
            Alamofire.request(url).validate().responseJSON { response in
                if let error = response.error {
                    completion(nil, Error.failed(error.localizedDescription))
                    return
                }
                guard let json = response.result.value else {
                    completion(nil, Error.failed("Failed to parse JSON from: \(url)"))
                    return
                }
                parseSearchPhotos(json: json, completion: completion)
            }
        } catch (let error as Error) {
            completion(nil, error)
        } catch {
            completion(nil, Error.failed("Unknown error"))
        }
    }
    
    class func parseSearchPhotos(json: Any, completion: @escaping SearchCompletion) {
        
        do {
            let response: FlickrResponse = try unbox(dictionary: json as! UnboxableDictionary)
            switch response.stat {
            case "ok":
                completion(response.photoContainer?.photos, nil)
            default:
                let message = response.message ?? "Unknown error"
                completion(nil, Error.failed(message))
            }
            
        } catch (let error as UnboxError) {
            completion(nil, Error.failed(error.localizedDescription))
        } catch {
            completion(nil, Error.failed("Unknown error"))
        }
    }
}


extension FlickrService {
    
    typealias GetImageCompletion = (UIImage?, Error?)->()

    class func getImage(withPhoto photo: FlickrPhoto, size: FlickrPhotoSize, completion: @escaping GetImageCompletion) {
        
        do {
            let url = try URLBuilder.getImage(withSize: size, id: photo.id, farm: photo.farm, server: photo.server, secret: photo.secret)
            Alamofire.request(url).validate().responseImage(completionHandler: { response in
                if let error = response.error {
                    completion(nil, Error.failed(error.localizedDescription))
                    return
                }
                guard let image = response.result.value else {
                    completion(nil, Error.failed("Failed to load image from: \(url)"))
                    return
                }
                completion(image, nil)
            })
        } catch (let error as Error) {
            completion(nil, error)
        } catch {
            completion(nil, Error.failed("Unknown error"))
        }
    }
}
