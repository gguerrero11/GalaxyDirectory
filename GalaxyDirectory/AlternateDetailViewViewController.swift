//
//  AlternateDetailViewViewController.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/10/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import UIKit

// This is to provide a more traditional detail view that gets pushed on to the view

class AlternateDetailViewViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var affiliation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let person = person else { return }
        let nameText = person.lastName.isEmpty ? person.firstName : "\(person.lastName), \(person.firstName)"
        name.text = nameText
        birthday.text = person.birthdate
        affiliation.text = person.affiliation
        imageView.image = person.profilePicture
        imageView.contentMode = .scaleAspectFit
    }
}
