//
//  File.swift
//  
//
//  Created by me on 09/02/2023.
//

import Foundation

#warning("Move to it's own library?")

protocol Mappable {}

extension Mappable {
 
    func map<T>(using performMap: (Self) -> T) -> T {
        performMap(self)
    }
}

extension NSObject: Mappable {}
