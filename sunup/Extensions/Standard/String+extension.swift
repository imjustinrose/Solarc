//
//  String+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension String {
    
    var convertToTimeDecimal: Float {
        let time = self.components(separatedBy: ":")
        
        guard let hours = Int(time[0]), var minutes = Float(time[1]) else { return -1 }
        
        minutes = minutes.hundredths
        
        return Float(hours) + minutes
    }
    
    var meridiem: String {
        let df = DateFormatter()
        df.dateFormat = DateFormat.military
        
        guard let date = df.date(from: self) else { return self }
        
        df.dateFormat = DateFormat.meridiem
        return df.string(from: date)
    }
    
    var military: String {
        let df = DateFormatter()
        df.dateFormat = DateFormat.meridiem
        
        guard let date = df.date(from: self) else { return self }
        
        df.dateFormat = DateFormat.military
        return df.string(from: date)
    }
}
