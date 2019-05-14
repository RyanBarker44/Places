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

protocol DetailViewControllerDelegate: class
{
    func submit(p: Place)
}
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
    
//    func configureView(){
//        if let detail = detailItem{
//            if let label = detailDescriptionLabe{
//                label.text = detail.description()
//            }
//        }
//    }
    
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
    
    func addToModel()
    {

        if var name = nameField.text, var address = addressField.text, var lat = latField.text, var long = longField.text
        {
            if (lat == "" && long == "") && (address != "") || (address != p?.address){
                // if p.address != "" && p.name != ""{
                
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
                // Reverse-Geo
                
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
                        //self.nameField.text = name
                        //let nameLine = name
                        self.nameField.text = name
                        self.addressField.text = address
                        
                    }
                    let place = Place(n: name, la: lat , lo: long, a: address)
                    self.delegate?.submit(p: place)
                }
            }
            if (name != p?.name || address != p?.address || lat != p?.lat || long != p?.long){
                
                name = nameField.text ?? "Empty"
                address = addressField.text ?? "Empty"
                lat = latField.text ?? "Empty"
                long = longField.text ?? "Empty"
                
                let place = Place(n: name, la: lat , lo: long, a: address)
                self.delegate?.submit(p: place)
            }
            else{
                print("HEKKE")
                name = nameField.text ?? "Empty"
                address = addressField.text ?? "Empty"
                lat = latField.text ?? "Empty"
                long = longField.text ?? "Empty"
                
                let place = Place(n: name, la: lat , lo: long, a: address)
                delegate?.submit(p: place)
            }
            
            
            
//            p?.name = nameField.text ?? "Empty"
//            p?.address = addressField.text ?? "Empty"
//            p?.lat = latField.text ?? "Empty"
//            p?.long = longField.text ?? "Empty"
//            
//            let place = Place(n: name, la: lat , lo: long, a: address)
                
//                nameField.text = ""
//                addressField.text = ""
//                latField.text = ""
//                longField.text = ""
                
                //delegate?.submit(p: place)
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//
//        if nameField != nil
//        {
//            addToModel()
//        }
//        if p?.name != nil && p?.address != nil{
//            p?.name = nameField.text ?? ""
//            p?.address = addressField.text ?? ""
//        }
//    }
    
     //prevents triggering addToModel() when clicking on another cell
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        /// adding cells when the address is given
        if (addressField.text != "") &&
            (latField.text == "" && longField.text == "") &&
            (p?.name == nil && p?.address == nil)
        {
            print("where am i 1")
            addToModel()
        }
            /// for adding cells to the table when the longitude and latitude are given
        else if (latField.text != "" && longField.text != "") &&
            (nameField.text == "" || addressField.text == "") &&
            (p?.lat == nil && p?.long == nil)
        {
            print("where am i 2")
            addToModel()
        }
            
            /// editing exisiting cells in the table
        else if p?.name != nil
        {
            print("where am i 3")
            addToModel()
        }
        setupMap()
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if nameField != nil
//        {
//            addToModel()
//        }
//        if p?.name != nil && p?.address != nil{
//            p?.name = nameField.text ?? ""
//            p?.address = addressField.text ?? ""
//        }
//    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        /// adding cells when the address is given
        if (addressField.text != "") &&
            (latField.text == "" && longField.text == "") &&
            (p?.name == nil && p?.address == nil)
        {
            print("where am i 1")
            addToModel()
        }
            /// for adding cells to the table when the longitude and latitude are given
        else if (latField.text != "" && longField.text != "") &&
            (nameField.text == "" || addressField.text == "") &&
            (p?.lat == nil && p?.long == nil)
        {
            print("where am i 2")
            addToModel()
        }
    
            /// editing exisiting cells in the table
        else if p?.name != nil
        {
            print("where am i 3")
            addToModel()
        }
        setupMap()
    }

    func configureView()
    {
    // Update the user interface for the detail item.
        if let pl = p
        {
            nameField.text = pl.name
            addressField.text = pl.address
            latField.text = String(pl.lat)
            longField.text = String(pl.long)
            //print("configuring")
        }
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
//        if p != nil{
//            nameField.text = p?.name
//            addressField.text = p?.address
//            latField.text = p?.lat
//            longField.text = p?.long
//        }
    }
    
    var detailItem: Place? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func setupMap()
    {
        if let lat = latField.text, let long = longField.text
        {
            var coordinates = CLLocationCoordinate2D()
            coordinates.latitude = Double(lat) ?? 0
            coordinates.longitude = Double(long) ?? 0
    
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
            detailMap.setRegion(region, animated: true)
            detailMap.setCenter(coordinates, animated: true)
    
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3))
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(self.nameField.text ?? "Error, no name found")"
                self.detailMap.addAnnotation(annotation)
                
            }
        }
    }
}




//func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//    if nameField != nil
//    {
//        addToModel()
//    }
//    if p?.name != nil && p?.address != nil{
//        p?.name = nameField.text ?? ""
//        p?.address = addressField.text ?? ""
//    }
//    return true
//}

//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if nameField != nil
//        {
//            addToModel()
//        }
//        if p?.name != nil && p?.address != nil{
//            p?.name = nameField.text ?? ""
//            p?.address = addressField.text ?? ""
//        }
//    }
//
//func textFieldDidEndEditing(_ textField: UITextField)
//{
//    /// adding cells when the address is given
//    if (nameField.text != "" && addressField.text != "") &&
//        (latField.text == "" && longField.text == "") &&
//        (p?.name == nil && p?.address == nil)
//    {
//        print("where am i 1")
//        addToModel()
//    }
//        /// for adding cells to the table when the longitude and latitude are given
//    else if (latField.text != "" && longField.text != "") &&
//        (nameField.text == "" || addressField.text == "") &&
//        (p?.lat == nil && p?.long == nil)
//    {
//        print("where am i 2")
//        addToModel()
//    }
//
//        /// editing exisiting cells in the table
//    else if p?.name != nil
//    {
//        print("where am i 3")
//        addToModel()
//    }
//}

//func configureMap()
//{
//    if let lat = latitudeTextField.text, let long = longitudeTextField.text
//    {
//        var coordinates = CLLocationCoordinate2D()
//        coordinates.latitude = Double(lat) ?? 0
//        coordinates.longitude = Double(long) ?? 0
//        //print(coordinates)
//
//        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
//        mapView.setRegion(region, animated: true)
//        mapView.setCenter(coordinates, animated: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3))
//        {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinates
//            self.mapView.addAnnotation(annotation)
//        }
//    }
//}
