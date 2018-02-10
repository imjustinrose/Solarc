//
//  Sun.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

struct Sun {
    var rise: String
    var set: String
    
    init(rise: String, set: String) {
        self.rise = rise.military
        self.set = set.military
    }
}
