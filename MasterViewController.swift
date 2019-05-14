//
//  MasterViewController.swift
//  PlacesAssignment
//
//  Created by Ryan Barker on 30/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import CoreLocation

let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

/// The Master view controller
class MasterViewController: UITableViewController, UITextFieldDelegate, DetailViewControllerDelegate{
    
    var detailViewController: DetailViewController? = nil
    
    var places = PlaceList()
    var edit = false
    let geo = CLGeocoder()
    var index: Int?
    var prevIndex: Int?
    
    /// Writes the data to a file
    func encodeFunc(){
        do{
            let fileURL = docs.appendingPathComponent("json")
            let encoder = JSONEncoder()
            let json = try encoder.encode(places.pList)
            try json.write(to: fileURL, options: .atomic)
        } catch{
            print("Error: \(error)")
        }
    }
    
    /// Reads the data from a file
    func decodeFunc(){
        do{
            let fileURL = docs.appendingPathComponent("json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            places.pList = try decoder.decode([Place].self, from: data)
        } catch{
            print("Error: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        decodeFunc()
       
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController!.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        encodeFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Segues
    
    /// The segue between the Master and Detail view, gets called everytime the views switches to detai
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARING")

        let vc = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        vc.delegate = self
        
        vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        vc.navigationItem.leftItemsSupplementBackButton = true
        
        if sender is UITableViewCell
        {
            edit = true
            prevIndex = index
            index = tableView.indexPathForSelectedRow?.row
            vc.p = places.pList[index ?? 0]
        }
        else{
            prevIndex = tableView.indexPathForSelectedRow?.row
            edit = false
        }

        encodeFunc()
    }

    // MARK: - Table View

    /// - Returns: The number of sections in the tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// - Returns: Returns the count of item in the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (places.pList.count)
    }
    
    /// - Returns: Returns the cell data from the array to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let line = places.pList[indexPath.row]
        cell.textLabel?.text = "\(line.name)"
        cell.detailTextLabel?.text = "\(line.address)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedObject = self.places.pList[sourceIndexPath.row]
        
        places.pList.remove(at: sourceIndexPath.row)
        places.pList.insert(movedObject, at: destinationIndexPath.row)
        
        encodeFunc()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            places.pList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        encodeFunc()
    }
    
    /// Submits the place item to be added onto the list
    /// - Parameter p: The place item to insert into the array
    func submit(p: Place)
    {
        print("SUBMITTING")
        
        // If a cell is clicked on, edit is true, existing cell updated
        if edit == true
        {
            print("Editing")
            
            if prevIndex == nil{
                prevIndex = index
            }
            places.pList[index!] = p  //FOR PHONE
            //places.pList[prevIndex ?? 0] = p
        }
        else // New cell is added
        {
            print("Name ",p.name)
            places.addPlace(p: p)
        }
        
        tableView.reloadData()
    }
}

