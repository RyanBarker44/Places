//
//  Place.swift
//  PlacesAssignment
//
//  Created by Ryan Barker on 30/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import Foundation

class Place: Codable{
    
    var name: String
    var address: String
    var lat: String
    var long: String
    
    /// Initialises the place object
    /// - Parameter n: The name of the place
    /// - Parameter la: The latitude coordinate of the place
    /// - Parameter lo: The longitude coordinate of the place
    /// - Parameter a: The address line for the place
    init(n: String, la: String, lo: String, a: String){
        name = n
        address = a
        lat = la
        long = lo
    }
    
    /// Creates a placeholder object in the case that no parameters are given
    init(){
        name = "Placeholder"
        address = ""
        lat = ""
        long = ""
    }
}
