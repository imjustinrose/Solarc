//
//  Double+conversions.swift
//  sunup
//
//  Created by Justin Rose on 3/10/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

extension Double {
    var kelvinToFahrenheit: Double { return (9.0 / 5) * (self - 273) + 32 }
    var metersPerSecondToMPH: Double { return self * 2.23694 }
}
