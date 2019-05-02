//
//  DetailViewController.swift
//  PlacesAssignment
//
//  Created by Ryan Barker on 30/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import Foundation

protocol DetailViewControllerDelegate: class
{
    func submit(p: Place)
}
class DetailViewController: UITableViewController, UITextFieldDelegate {

    var delegate: DetailViewControllerDelegate?
    var p: Place?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!

    var places = PlaceList()
    
//    func configureView(){
//        if let detail = detailItem{
//            if let label = detailDescriptionLabe{
//                label.text = detail.description()
//            }
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if p != nil{
            nameField.text = p?.name
            addressField.text = p?.address
            latField.text = p?.lat
            longField.text = p?.long
        }
    }
    
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
        if let name = nameField.text, let address = addressField.text, let lat = latField.text, let long = longField.text
        {
            if name != "" && address != ""
            {
                let place = Place(n: name, la: lat , lo: long, a: address)
                
                nameField.text = ""
                addressField.text = ""
                latField.text = ""
                longField.text = ""
                
                delegate?.submit(p: place)
            }
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

        if nameField != nil
        {
            addToModel()
        }
        if p?.name != nil && p?.address != nil{
            p?.name = nameField.text ?? ""
            p?.address = addressField.text ?? ""
        }
        return true
    }
    
    var detailItem: Place? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
}

