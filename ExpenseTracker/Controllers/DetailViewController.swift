//
//  ViewController.swift
//  Places
//
//  Created by Ryan Barker on 11/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import UIKit
import Foundation

protocol DetailViewControllerDelegate
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if let name = nameField.text, let address = addressField.text, let lat = latField.text, let long = longField.text
        {
            if name != "" && address != ""
            {
                let place = Place(n: name, la: lat , lo: long, a: address)
                
                guard let d = delegate else { return }
                d.submit(p: place)
            }
        }
    }
}
