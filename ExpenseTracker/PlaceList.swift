//
//  PlaceList.swift
//  Places
//
//  Created by Ryan Barker on 9/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import Foundation

class PlaceList{
    
    var pList: [Place]
    
    init(){
        pList = []
    }
    
    func addPlace(p: Place){
        pList.append(p)
    }
}
