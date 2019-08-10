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
    var selectedPerson: Person?

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
        cell.affiliation.text = person.affiliation
        cell.birthdate.text = "DOB: " + person.birthdate
        cell.forceSensitive.isHidden = !person.forceSensitive
        cell.selectionStyle = .none
        cell.profilePic.clipsToBounds = true
        
        // If picture exists...
        if let pic = person.profilePicture {
            cell.profilePic.image = pic
        } else {
            // then check storage...
            if let storedImage = Storage.GetImage(forID: person.id) {
                cell.profilePic.image = storedImage
                person.profilePicture = storedImage
            } else {
                // then download from URL (and save)
                if let picURL = person.profilePictureURL {
                    cell.profilePic.load(url: picURL, forID: person.id)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        selectedPerson = personArray[indexPath.row]
        tableView.performBatchUpdates({
            // this animates the cell height
        }) { (bool) in
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandedHeight: CGFloat = view.frame.height - 125
        let shrunkHeight: CGFloat = 121
        var result = shrunkHeight
        if let selectedRow = selectedIndex?.row {
            result = (selectedRow == indexPath.row) ? expandedHeight : shrunkHeight
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" { // would normally use constants
            if let detailView = segue.destination as? AlternateDetailViewViewController, (selectedPerson != nil) {
                detailView.person = selectedPerson!
            }
        }
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
    func load(url: URL, forID: Int) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        Storage.StoreImage(image: image, forID: forID)
                    }
                }
            }
        }
    }
}

