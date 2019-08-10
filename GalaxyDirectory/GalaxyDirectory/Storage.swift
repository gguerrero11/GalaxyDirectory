//
//  Storage.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/9/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import Foundation

struct Storage {
    static let defaults = UserDefaults.standard
    
    static func SaveDict(dict: [[String:Any]]) {
        defaults.set(dict, forKey: "data")
    }
    
    static func LoadDict()->[[String:Any]]? {
        return defaults.value(forKey: "data") as? [[String : Any]]
    }
}
