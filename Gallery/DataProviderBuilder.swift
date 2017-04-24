//
//  DataProviderBuilder.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation

class DataProviderBuilder {
    
    class func sample() -> SampleDataProvider {
        return SampleDataProvider()
    }
    
    class func flickr() -> FlickrDataProvider {
        return FlickrDataProvider()
    }
}
