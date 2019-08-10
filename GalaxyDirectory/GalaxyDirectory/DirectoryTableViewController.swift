//
//  DirectoryTableViewController.swift
//  GalaxyDirectory
//
//  Created by Gabe Guerrero on 8/9/19.
//  Copyright © 2019 Gabriel Guerrero. All rights reserved.
//

import UIKit
import Alamofire

class DirectoryTableViewController: UITableViewController {
    
    let requestURL = "https://edge.ldscdn.org/mobile/interview/directory"
    let session = Alamofire.Session()
    var personArray = [Person]()
    var affiliations = Set<String>()
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storageDictArray = Storage.LoadDict() {
            convertDictToPersons(dictArray: storageDictArray)
            tableView.reloadData()
        } else {
            session.request(requestURL).responseJSON { (response) in
                if let json = try? response.result.get() as? [String:[[String:Any]]] {
                    guard let dictArray = json["individuals"] else { return }
                    self.convertDictToPersons(dictArray: dictArray)
                    Storage.SaveDict(dict: dictArray)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func convertDictToPersons(dictArray: [[String:Any]]) {
        dictArray.forEach({ (personDict) in
            let person = Person(dict: personDict)
            self.affiliations.insert(person.affiliation)
            self.personArray.append(person)
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1  //affiliations.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        let person = personArray[indexPath.row]
        cell.nameLabel.text = person.firstName + " " + person.lastName
        
        if let picURL = person.profilePicture {
            cell.profilePic.load(url: picURL)
            cell.profilePic.clipsToBounds = true
        }
        return cell
    }
    
}

class PersonCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliation: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var forceSensitive: UILabel!
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

