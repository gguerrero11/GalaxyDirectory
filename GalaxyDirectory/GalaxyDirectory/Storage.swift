//
//  Storage.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/9/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

struct Storage {

//    Attempted to store the imageStorage dictionary instead, but somewhat overkill. Just opted to use the defaults key with
//    its ID appended as a more simpler solution
//    fileprivate static var imageStorage = [Int:Data]()

    
    fileprivate static let defaults = UserDefaults.standard
    
    static func SaveDict(dict: [[String:Any]]) {
        defaults.set(dict, forKey: "data")
    }
        
    static func LoadDict()->[[String:Any]]? {
        return defaults.value(forKey: "data") as? [[String : Any]]
    }
        
    static func GetImage(forID: Int)->UIImage? {
        guard let defaultImageData = defaults.value(forKey: "imageStorageID: \(forID)") as? Data else { return nil }
        guard let image = UIImage(data: defaultImageData) else { return nil }
        return image
    }
    
    static func StoreImage(image: UIImage, forID: Int) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            defaults.set(imageData, forKey: "imageStorageID: \(forID)")
        }
    }
}
