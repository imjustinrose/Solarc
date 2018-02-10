//
//  Date+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import Foundation

extension Date {
    var current: String {
        let df = DateFormatter()
        df.dateFormat = DateFormat.military
        
        return df.string(from: Date())
    }
    
    func getTimeOfDay(sunrise: String, sunset: String) -> TimeOfDay {
        let df = DateFormatter()
        df.dateFormat = DateFormat.military
        
        let time = df.string(from: self).military.convertToTimeDecimal
        let sunrise = sunrise.military.convertToTimeDecimal - 0.25
        let morning = sunrise + 0.5
        let afternoon: Float = 12
        let sunset = sunset.military.convertToTimeDecimal - 0.25
        let evening = sunset + 0.5
        
        switch time {
        case sunrise ..< morning: return .dawn
        case morning ..< afternoon: return .morning
        case afternoon ..< sunset: return .afternoon
        case sunset ..< evening: return .dusk
        default: return .evening // evening ..< sunrise
        }
    }
}
