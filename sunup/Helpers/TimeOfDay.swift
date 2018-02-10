//
//  TimeOfDay.swift
//  sunup
//
//  Created by Justin Rose on 2/8/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

// `rawValue` matches image names
enum TimeOfDay: String {
    case dawn = "sunrise_bg"
    case morning = "morning_bg"
    case afternoon = "day_bg"
    case dusk = "sunset_bg"
    case evening = "night_bg"
    case placeholder = "placeholder_bg"
}
