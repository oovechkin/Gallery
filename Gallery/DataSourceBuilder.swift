//
//  DataSourceBuilder.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation

class DataSourceBuilder {
    
    class func sample() -> GalleryDataSourceProtocol {
        return SampleDataSource()
    }
}
