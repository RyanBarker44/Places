//
//  MasterViewController.swift
//  Places
//
//  Created by Ryan Barker on 19/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import CoreLocation

let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

class MasterViewController: UITableViewController, UITextFieldDelegate, DetailViewControllerDelegate{
    
    var places = PlaceList()
    var edit = false
    let geo = CLGeocoder()
    
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
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        decodeFunc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        encodeFunc()
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
        encodeFunc()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.places.pList[sourceIndexPath.row]
        
        places.pList.remove(at: sourceIndexPath.row)
        places.pList.insert(movedObject, at: destinationIndexPath.row)
        encodeFunc()
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
        encodeFunc()
        //decodeFunc()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//
//        print("Exiting")
//
//        encodeFunc()
//        //decodeFunc()
//        print("Got \(places.pList.count) places:")
//        for place in places.pList {
//            print(place.name)
//        }
//
//    }
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
