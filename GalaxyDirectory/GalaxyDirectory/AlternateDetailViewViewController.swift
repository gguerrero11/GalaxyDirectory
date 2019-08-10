//
//  AlternateDetailViewViewController.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/10/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import UIKit

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

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
