//
//  ExpenseItem.swift
//  ExpenseTracker
//
//  Created by Ryan Barker on 19/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import Foundation

class ExpenseItem{
    
    var cat: String
    var dsc: String
    var val: Float
    
    init(d: String, v: Float, c: String){
        dsc = d
        val = v
        cat = c
    }
    
    func description() -> String{
        return self.dsc + " " + String(self.val)
    }
}
