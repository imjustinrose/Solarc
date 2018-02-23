//
//  Constants.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

struct Constants {
    
    static let isMilitaryTime = "isMilitaryTime"
    
    struct CAKeyframeAnimation {
        static let positionKeyPath = "position"
        static let arcKey = "arc"
    }
    
    struct OpenWeather {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/weather"
        static let appid = "6c9ef27738b15406b6ba22d5c576020a"
    }
    
    struct OpenWeatherParameterKeys {
        static let latitude = "lat"
        static let longitude = "lon"
        static let appid = "appid"
    }
    
    struct MountainRangeOffset {
        static let backRange: CGFloat = 0.15
        static let middleRange: CGFloat = 0.23
        static let frontRange: CGFloat = 0.33
    }
}
