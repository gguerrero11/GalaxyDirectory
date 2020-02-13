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
    var affiliations = [String]()
    var selectedIndex: IndexPath?
    var selectedPerson: Person?
    var cellOpen: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getDirectory()
    }
    
    func getDirectory() {
        if let storageDictArray = Storage.LoadDict() {
            convertDictToPersons(dictArray: storageDictArray)
            tableView.reloadData()
        } else {
            downloadDirectory()
        }
    }
    
    func convertDictToPersons(dictArray: [[String:Any]]) {
        // Using a Set easily eliminates duplicates of affiliations
        var affiliationSet = Set<String>()
        
        dictArray.forEach({ (personDict) in
            let person = Person(dict: personDict)
            affiliationSet.insert(person.affiliation)
            self.personArray.append(person)
        })
        
        // converts to an array that can be used for section titles
        for affiliation in affiliationSet.sorted() {
            affiliations.append(affiliation)
        }
    }
    
    func downloadDirectory() {
        session.request(requestURL).responseJSON { (response) in
            if let json = try? response.result.get() as? [String:[[String:Any]]] {
                guard let dictArray = json["individuals"] else { return }
                self.convertDictToPersons(dictArray: dictArray)
                Storage.SaveDict(dict: dictArray)
                self.tableView.reloadData()
            }
        }
    }
    
    func configure(cell: PersonCell, withPerson person: Person) {
        cell.nameLabel.text = person.firstName + " " + person.lastName
        cell.affiliation.text = person.affiliation
        cell.birthdate.text = "DOB: " + person.birthdate
        cell.forceSensitive.isHidden = !person.forceSensitive
        cell.profilePic.clipsToBounds = true
        cell.selectionStyle = .none
        
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
    }
    
    func filterByAffiliation(atSection section: Int) -> [Person] {
        let affiliationFilter = affiliations[section]
        let filteredPersonArray = personArray.filter { $0.affiliation == affiliationFilter }
        return filteredPersonArray
    }
    
    func sortFilteredAffiliation(atSection section: Int) -> [Person] {
        let filteredPersonArray = filterByAffiliation(atSection: section)
        let sortedPersonArray = filteredPersonArray.sorted {$0.firstName < $1.firstName}
        return sortedPersonArray
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return affiliations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return affiliations[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterByAffiliation(atSection: section).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedPersonArray = sortFilteredAffiliation(atSection: indexPath.section)
        let person = sortedPersonArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        configure(cell: cell, withPerson: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let personArray = sortFilteredAffiliation(atSection: indexPath.section)
        selectedPerson = personArray[indexPath.row]
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandedHeight: CGFloat = view.frame.height - 125
        let shrunkHeight: CGFloat = 121
        var result = shrunkHeight
        
        // if the selected row is the row this method is inquiring about...
        if selectedIndex == indexPath {
            // and if the cell is already opened...
            if cellOpen {
                // close the cell
                result = shrunkHeight
                cellOpen = false
                selectedIndex = nil
            } else {
                // open the cell
                result = expandedHeight
                cellOpen = true
            }
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

