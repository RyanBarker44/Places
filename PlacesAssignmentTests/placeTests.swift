//
//  placeTests.swift
//  placeTests
//
//  Created by Ryan Barker on 30/4/19.
//  Copyright © 2019 Ryan Barker. All rights reserved.
//

import XCTest
@testable import PlacesAssignment

class PlacesTests: XCTestCase {
        
    var places: PlaceList!
        
    override func setUp() {
        super.setUp()
        places = PlaceList()
    }
        
    override func tearDown() {
        places = nil
    }
    
    /// Test
    
    func testAddPlace(){
            
        let p = Place(n: "Brisbane", la: "117.02", lo: "376.78", a: "Brisbane CBD")
            
        places.addPlace(p: p)
        XCTAssertTrue(places.pList.count == 1)
            
        let p2 = Place(n: "Sydney", la: "199.02", lo: "456.78", a: "Sydney CBD")
        places.addPlace(p: p2)
        XCTAssertTrue(places.pList.count == 2)
    }
    
    /// Tests detailed initialisation of type Place
    func testPlaceItem(){
            
        let p = Place(n: "Brisbane", la: "117.02", lo: "376.78", a: "Brisbane CBD")
            
        let n = "Brisbane"
        let la = "117.02"
        let lo = "376.78"
        let a = "Brisbane CBD"
            
        XCTAssertEqual(p.name, n)
        XCTAssertEqual(p.lat, la)
        XCTAssertEqual(p.long, lo)
        XCTAssertEqual(p.address, a)
    }
    /// Tests empty Initialisation of type Place
    func testEmptyPlaceItem(){
        
        let p = Place()
        
        XCTAssertEqual(p.name, "Placeholder")
        XCTAssertEqual(p.address, "")
        XCTAssertEqual(p.lat, "")
        XCTAssertEqual(p.long, "")
    }
}
