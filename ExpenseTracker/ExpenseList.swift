//
//  ExpenseList.swift
//  ExpenseTracker
//
//  Created by Ryan Barker on 19/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import Foundation

class ExpenseList{
    
    var eList: [ExpenseItem] //= [:]
    
    init(){
        eList = []
    }
    
    func addExpense(cat: String, exp: ExpenseItem)
    {
        eList.append(exp)
    }
    
    func getExpenses() -> [ExpenseItem]?
    {
        return eList
    }
}

//class ExpenseList{
//
//    var eListDict: [String: [ExpenseItem]] //= [:]
//
//    init(){
//        eListDict = [:]
//    }
//
//    func addExpense(cat: String, exp: ExpenseItem){
//
//        if eListDict.keys.contains(cat){
//            eListDict[cat]?.append(exp)
//        }
//        else{
//            eListDict[cat] = [exp]
//        }
//    }
//
//    func getExpenses() -> [String]?
//    {
//        var expenseList: [String] = []
//
//        if eListDict.keys.count != 0
//        {
//            // HOW TO ACCESS THE CLASS VARIABLES //
//            for k in eListDict.keys
//            {
//                for row in eListDict[k]!
//                {
//                    print("\(k) \(row.description())")
//                    expenseList.append("\(k) \(row.description())")
//                }
//            }
//        }
//        return expenseList
//    }
//
//    func getTotal(cat: String) -> Int{
//        var total = 0
//
//        //        for row in dict[key]!
//        //        {
//        //            let list = row.components(separatedBy: ", ")
//        //            let lowerBound = list[1].index(list[1].startIndex, offsetBy: 1)
//        //            let upperBound = list[1].index(list[1].endIndex, offsetBy: -2)
//        //            let mySubstring = Int(list[1][lowerBound..<upperBound])
//        //            total += mySubstring!
//        //        }
//        return total
//    }
//}
