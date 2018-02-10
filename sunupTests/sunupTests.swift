//
//  sunupTests.swift
//  sunupTests
//
//  Created by Justin Rose on 2/8/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import XCTest
@testable import sunup

class sunupTests: XCTestCase {
    
    func testMeridiemTime() {
        let times = ["00:00", "12:12", "03:49", "01:59", "15:59"].map { $0.meridiem }
        
        XCTAssertEqual(times, ["12:00 AM", "12:12 PM", "3:49 AM", "1:59 AM", "3:59 PM"])
    }
    
    func testMilitaryTime() {
        let times = ["12:00 AM", "12:12 PM", "3:49 AM", "1:59 AM", "3:59 PM"].map { $0.military }
        
        XCTAssertEqual(times, ["00:00", "12:12", "03:49", "01:59", "15:59"])
    }
    
}
