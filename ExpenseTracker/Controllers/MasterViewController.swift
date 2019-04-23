//
//  MasterViewController.swift
//  Places
//
//  Created by Ryan Barker on 19/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController, UITextFieldDelegate, DetailViewControllerDelegate{
    
    var places = PlaceList()
    var edit = false
    let geo = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (places.pList.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let line = places.pList[indexPath.row]
        cell.textLabel?.text = "\(line.name)"
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            places.pList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.places.pList[sourceIndexPath.row]
        
        places.pList.remove(at: sourceIndexPath.row)
        places.pList.insert(movedObject, at: destinationIndexPath.row)
    }
   
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let vc = segue.destination as? DetailViewController else {return}
        vc.delegate = self
        
        if sender is UITableViewCell
        {
            edit = true
            vc.p = places.pList[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    func submit(p: Place)
    {
        if (p.lat == "" && p.long == "") || edit == true{
            
            geo.geocodeAddressString(p.address) {
                guard let placeMarks = $0 else { print("Got error: \(String(describing: $1))")
                    return
                }
                for placeMark in placeMarks{
                    
                    guard let lat = placeMark.location?.coordinate.latitude else{ continue }
                    guard let long = placeMark.location?.coordinate.longitude else{ continue }
                    
                    p.lat = String(lat)
                    p.long = String(long)
                }
            }
        }
        
        if edit == true
        {
            print("Editing")
            places.pList[tableView.indexPathForSelectedRow?.row ?? 0] = p
            edit = false
        }
        else
        {
            places.addPlace(p: p)
        }
        
        tableView.reloadData()
    }
}
