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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.request(requestURL).responseJSON { (response) in
            /*                      SAMPLE JSON
             {
                 "individuals": [
                     {
                         "id":1,
                         "firstName":"Luke",
                         "lastName":"Skywalker",
                         "birthdate":"1963-05-05",
                         "profilePicture":"https://edge.ldscdn.org/mobile/interview/07.png",
                         "forceSensitive":true,
                         "affiliation":"JEDI"
                     },
             */
            
            
            if let json = try? response.result.get() as? [String:[[String:Any]]] {
                guard let array = json["individuals"] else { return }
                array.forEach({ (personDict) in
                    self.personArray.append(Person(dict: personDict))
                })
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
