//
//  Location.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

struct System: Codable {
    let sunrise: Int64
    let sunset: Int64
}

struct Location: Codable {
    let sys: System
}
