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

class MasterViewController: UITableViewController, UITextFieldDelegate, DetailViewControllerDelegate{
    
    var detailViewController: DetailViewController? = nil
    
    var places = PlaceList()
    var edit = false
    let geo = CLGeocoder()
    
    var index: Int?
    var prevIndex: Int?
    
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
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        //index = places.pList.count
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARING")
        //guard let vc = segue.destination as? DetailViewController else {return}
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (places.pList.count)
    }

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
    
    func submit(p: Place)
    {
        print("SUBMITTING")
//        if (p.lat == "" || p.long == "") || edit == true{
//       // if p.address != "" && p.name != ""{
//            
//            geo.geocodeAddressString(p.address) {
//                guard let placeMarks = $0 else { print("Got error: \(String(describing: $1))")
//                    return
//                }
//                for placeMark in placeMarks{
//                    
//                    guard let lat = placeMark.location?.coordinate.latitude else{ continue }
//                    guard let long = placeMark.location?.coordinate.longitude else{ continue }
//                    
//                    p.lat = String(lat)
//                    p.long = String(long)
//                }
//            }
//        }
//        else if (p.address == ""){
//            // Reverse-Geo
//            
//            // -27.46
//            //153.03
//
//            let addressLocation = CLLocation(latitude: Double(p.lat) ?? 0, longitude: Double(p.long) ?? 0)
//            print("ENTERING REVERSE")
//            geo.reverseGeocodeLocation(addressLocation)
//            {
//                print("REVERSING")
//                guard let placeMarks = $0 else { print("Got error: \(String(describing: $1))")
//                    return
//                }
//
//                for placeMark in placeMarks {
//
//                    guard let name = placeMark.name else { print("didnt find name")
//                        continue }
//                    guard let address = placeMark.thoroughfare else { print("didn't find address")
//                        continue }
//                    guard let number = placeMark.subThoroughfare else { print("didn't find address")
//                        continue }
//                    guard let city = placeMark.locality else { continue }
//                    guard let postcode = placeMark.postalCode else { continue }
//                    guard let state = placeMark.administrativeArea else { continue }
//                    guard let country = placeMark.country else { continue }
//
//                    let wholeAddress = ("\(number) \(address), \(city), \(postcode), \(state), \(country)")
//
//                    p.address = wholeAddress
//                    p.name = name
//                }
//                self.tableView.reloadData()
//            }
//        }
        if edit == true
        {
            print("Editing")
            
            if prevIndex == nil{
                prevIndex = index
            }
            print("editing index:", index)
            print("previous index:", prevIndex)
            //places.pList[index!] = p  FOR PHONE
            
            places.pList[prevIndex ?? 0] = p
        }
        else
        {
            print("Name ",p.name)
            places.addPlace(p: p)
        }
        
        tableView.reloadData()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        print("Dissapearing")
//        prevIndex = index
//    }
    
}

