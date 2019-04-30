//
//  Place.swift
//  Places
//
//  Created by Ryan Barker on 9/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import Foundation

class Place: Codable{

    var name: String
    var address: String
    var lat: String
    var long: String
    
    init(n: String, la: String, lo: String, a: String){
        name = n
        address = a
        lat = la
        long = lo
    }
}
