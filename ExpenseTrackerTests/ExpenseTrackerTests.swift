//
//  ExpenseTrackerTests.swift
//  PlacesTests
//
//  Created by Ryan Barker on 11/3/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import XCTest
@testable import ExpenseTracker

class ExpenseTrackerTests: XCTestCase {

    var places: PlaceList!
    
    override func setUp() {
        super.setUp()
        places = PlaceList()
    }
    
    override func tearDown() {
        places = nil
    }

    func testAddPlace(){
        
        let p = Place(n: "Brisbane", la: "117.02", lo: "376.78", a: "Brisbane CBD")
        
        places.addPlace(p: p)
        XCTAssertTrue(places.pList.count == 1)
        
        let p2 = Place(n: "Sydney", la: "199.02", lo: "456.78", a: "Sydney CBD")
        places.addPlace(p: p2)
        XCTAssertTrue(places.pList.count == 2)
    }
}
