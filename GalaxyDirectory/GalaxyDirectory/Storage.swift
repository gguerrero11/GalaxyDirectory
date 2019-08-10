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
    
    var imageStorage = [Int:Data]()
    
    fileprivate static let defaults = UserDefaults.standard
    
    static func SaveDict(dict: [[String:Any]]) {
        defaults.set(dict, forKey: "data")
    }
    
    static func LoadDict()->[[String:Any]]? {
        return defaults.value(forKey: "data") as? [[String : Any]]
    }
    
    static func GetImage(forID: Int)->UIImage {
        let imageData = UIImage.jpegData(<#T##UIImage#>)
    }
    
    static func SaveImage(image: UIImage, forID: Int) {
        let imageData = UIImage.jpegData(image)
        
    }
    
    
//    // Get image data. Here you can use UIImagePNGRepresentation if you need transparency
//    NSData *imageData =
//    
//    // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
//    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
//    
//    // Write image data to user's folder
//    [imageData writeToFile:imagePath atomically:YES];
//    
//    // Store path in NSUserDefaults
//    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:kPLDefaultsAvatarUrl];
//    
//    // Sync user defaults
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
