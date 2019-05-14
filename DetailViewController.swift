//
//  DetailViewController.swift
//  PlacesAssignment
//
//  Created by Ryan Barker on 30/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

/// The protocol between the Master and Detail view, allows the use of the submit function in the detail view
protocol DetailViewControllerDelegate: class
{
    func submit(p: Place)
}
/// The Detail view controller
class DetailViewController: UITableViewController, UITextFieldDelegate {

    var delegate: DetailViewControllerDelegate?
    var p: Place?
    let geo = CLGeocoder()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    @IBOutlet weak var detailMap: MKMapView!
    
    var places = PlaceList()
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        if p != nil
        {
            nameField.text = p?.name
            addressField.text = p?.address
            if let lat = p?.lat
            {
                latField.text = String("\(lat)")
            }
            if let long = p?.long
            {
                longField.text = String("\(long)")
            }
        }
        else{
            nameField.text = ""
            addressField.text = ""
            latField.text = ""
            longField.text = ""
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    //
    /// Transforms and adds data to the model through the masterview
    func addToModel()
    {
        if var name = nameField.text, var address = addressField.text, var lat = latField.text, var long = longField.text
        {
            if (lat == "" && long == "") && (address != "") || (address != p?.address){
                
                // Forward Geo-Locating
                geo.geocodeAddressString(address) {
                    guard let placeMarks = $0 else { print("Got placemarks 1 error: \(String(describing: $1))")
                        return
                    }
                    for placeMark in placeMarks{
                        
                        guard let searchLat = placeMark.location?.coordinate.latitude else{ continue }
                        guard let searchLong = placeMark.location?.coordinate.longitude else{ continue }
                        guard let searchName = placeMark.name else { print("didnt find name")
                            continue }
                        
                        lat = String(searchLat)
                        long = String(searchLong)
                        
                        if self.nameField.text == ""{
                            name = searchName
                            self.nameField.text = name
                            print(name)
                        }
                        
                        self.latField.text = lat
                        self.longField.text = long
                    }
                    
                    let place = Place(n: name, la: lat , lo: long, a: address)
                    self.delegate?.submit(p: place)
                }
            }
            else if (addressField.text == "" && (latField.text != "" && longField.text != "")){
                // Reverse-Geo locating
                
                // -27.46
                //153.03
                
                let addressLocation = CLLocation(latitude: Double(lat) ?? 0, longitude: Double(long) ?? 0)
                print("ENTERING REVERSE")
                geo.reverseGeocodeLocation(addressLocation)
                {
                    print("REVERSING")
                    guard let placeMarks = $0 else { print("Got placemarks 2 error: \(String(describing: $1))")
                        return
                    }
                    
                    for placeMark in placeMarks {
                        
                        guard let searchName = placeMark.name else { print("didnt find name")
                            continue }
                        guard let searchAddress = placeMark.thoroughfare else { print("didn't find address")
                            continue }
                        guard let number = placeMark.subThoroughfare else { print("didn't find address")
                            continue }
                        guard let city = placeMark.locality else { continue }
                        guard let postcode = placeMark.postalCode else { continue }
                        guard let state = placeMark.administrativeArea else { continue }
                        guard let country = placeMark.country else { continue }
                        
                        address = ("\(number) \(searchAddress), \(city), \(postcode), \(state), \(country)")
                        name = searchName
                        
                        self.nameField.text = name
                        self.addressField.text = address
                        
                    }
                    let place = Place(n: name, la: lat , lo: long, a: address)
                    self.delegate?.submit(p: place)
                }
            }
            else if (name != p?.name || address != p?.address || lat != p?.lat || long != p?.long){
                
                name = nameField.text ?? "Empty"
                address = addressField.text ?? "Empty"
                lat = latField.text ?? "Empty"
                long = longField.text ?? "Empty"
                
                let place = Place(n: name, la: lat , lo: long, a: address)
                self.delegate?.submit(p: place)
            }
            else{
                name = nameField.text ?? "Empty"
                address = addressField.text ?? "Empty"
                lat = latField.text ?? "Empty"
                long = longField.text ?? "Empty"
                
                let place = Place(n: name, la: lat , lo: long, a: address)
                delegate?.submit(p: place)
            }
        }
    }
    
    /// Checks the conditions for submitting data to be appended to the model when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        // Cells are added when given an address
        if (addressField.text != "") &&
            (latField.text == "" && longField.text == "") &&
            (p?.name == nil && p?.address == nil)
        {
            addToModel()
        }
        // Longitude and latitude are given, add new data
        else if (latField.text != "" && longField.text != "") &&
            (nameField.text == "" || addressField.text == "") &&
            (p?.lat == nil && p?.long == nil)
        {
            addToModel()
        }
        // Edit existing data
        else if p?.name != nil
        {
            addToModel()
        }
        setupMap()
        return true
    }
    
    /// Checks the conditions for submitting data to be appended to the model when leaving the text fields
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // Cells are added when given an address
        if (addressField.text != "") &&
            (latField.text == "" && longField.text == "") &&
            (p?.name == nil && p?.address == nil)
        {
            addToModel()
        }
        // Longitude and latitude are given, add new data
        else if (latField.text != "" && longField.text != "") &&
            (nameField.text == "" || addressField.text == "") &&
            (p?.lat == nil && p?.long == nil)
        {
            addToModel()
        }
    
        // Edit existing data
        else if p?.name != nil
        {
            addToModel()
        }
        setupMap()
    }
    
    /// Configures user interface with data from cells to edit
    func configureView(){
        
    // Check Place object exists and add data into text fields
        if let pl = p
        {
            nameField.text = pl.name
            addressField.text = pl.address
            latField.text = String(pl.lat)
            longField.text = String(pl.long)
        }
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    var detailItem: Place? {
        didSet {
            configureView()
        }
    }
    
    /// Set parameters for the map, getting latitude and longitude from text fieldsß
    func setupMap()
    {
        // Get coordinates
        if let lat = latField.text, let long = longField.text
        {
            // Insert coordinates into map
            var coordinates = CLLocationCoordinate2D()
            coordinates.latitude = Double(lat) ?? 0
            coordinates.longitude = Double(long) ?? 0
            
            // Define region
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
            detailMap.setRegion(region, animated: true)
            detailMap.setCenter(coordinates, animated: true)
    
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3))
            {
                // Add information to the pin position
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(self.nameField.text ?? "Error, no name found")"
                self.detailMap.addAnnotation(annotation)
            }
        }
    }
}
