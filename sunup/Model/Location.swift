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

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherDescription: Codable {
    let main: String
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let weather: [WeatherDescription]
    let main: Main
    let wind: Wind
    let sys: System
}
