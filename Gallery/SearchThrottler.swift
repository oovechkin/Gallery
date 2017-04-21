//
//  SearchThrottler.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import Foundation

class SearchThrottler {
    
    private let timeout = 1.0
    private var searchWork: DispatchWorkItem? = nil
    
    func execute(_ completion: @escaping () -> ()) {
        
        if let work = searchWork {
            work.cancel()
        }
        searchWork = DispatchWorkItem {
            completion()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: searchWork!)
    }
}
