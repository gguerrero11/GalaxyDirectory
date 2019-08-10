//
//  Person.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/9/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import UIKit

struct Person {
    var id: Int
    var firstName: String
    var lastName: String
    var birthdate: String
    var profilePicture: String
    var forceSensitive: Bool
    var affiliation: String
    
    init(dict: [String: Any]) {
        id              = dict["id"] as! Int
        firstName       = dict["firstName"] as! String
        lastName        = dict["lastName"] as! String
        birthdate       = dict["birthdate"] as! String
        profilePicture  = dict["profilePicture"] as! String
        forceSensitive  = dict["forceSensitive"] as! Bool
        affiliation     = dict["affiliation"] as! String
    }
}
