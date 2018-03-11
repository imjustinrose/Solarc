//
//  WeatherController+WeatherData.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

// MARK: - UIStatusBarStyle
extension WeatherController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Obtaining weather data
extension WeatherController {
    
    // Break up this function -- it's too long.
    func getWeatherData() {
        guard let longitude = locationManager.location?.coordinate.longitude,
              let latitude = locationManager.location?.coordinate.latitude,
              let url = buildURL(latitude: latitude, longitude: longitude) else { return }
        
        self.backgroundImageView.alpha = 0
        
        URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
            if let data = data {
                
                do {
                    
                    let json = try JSONDecoder().decode(Weather.self, from: data)
                    
                    self.weatherDataView.onSelection = { buttonIndex in
                        
                        UIView.transition(with: self.weatherDataView.textLabel,
                                          duration: 0.5,
                                          options: .transitionCrossDissolve,
                                          animations: { [unowned self] in
                                            
                                            switch buttonIndex {
                                            case -1: self.weatherDataView.textLabel.text = ""
                                            case 0:
                                                let min = String(format: "%.1f", json.main.temp_min.kelvinToFahrenheit)
                                                let max = String(format: "%.1f", json.main.temp_max.kelvinToFahrenheit)
                                                
                                                let mutableString = NSMutableAttributedString(string: "\(min) °F    \(max) °F")
                                                mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5), range: NSRange(location: 0, length: 8))
                                                
                                                self.weatherDataView.textLabel.attributedText = mutableString
                                            case 1: self.weatherDataView.textLabel.text = "\(Int(json.main.humidity))%"
                                            case 2: self.weatherDataView.textLabel.text = "\(String(format: "%.1f", json.wind.speed.metersPerSecondToMPH)) mph"
                                            case 3: self.weatherDataView.textLabel.text = "\(Int(json.main.pressure)) hPa"
                                            default: fatalError("Unknown button index attempted to be accessed.")
                                            }
                        })
                    }
                    
                    let df = DateFormatter()
                    df.dateFormat = self.circleView.militaryTime ? DateFormat.military : DateFormat.meridiem
                    
                    let sunrise = df.string(from: Date(timeIntervalSince1970: TimeInterval(json.sys.sunrise)))
                    let sunset = df.string(from: Date(timeIntervalSince1970: TimeInterval(json.sys.sunset)))
                    
                    self.circleView.sun = Sun(rise: sunrise, set: sunset)
                    
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(named: Date().getTimeOfDay(sunrise: sunrise, sunset: sunset).rawValue)
                        
                        self.circleView.setNeedsDisplay()
                        self.circleView.temperatureLabel.text = "\(String(format: "%.1f", json.main.temp.kelvinToFahrenheit)) °F"
                        self.circleView.descriptionLabel.text = json.weather.first?.main
                        self.sunTimeView.sunriseTimeLabel.text = sunrise
                        self.sunTimeView.sunsetTimeLabel.text = sunset
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            self.circleView.temperatureLabel.alpha = 1
                            self.circleView.descriptionLabel.alpha = 1
                            self.sunTimeView.sunriseTimeLabel.alpha = 1
                            self.sunTimeView.sunsetTimeLabel.alpha = 1
                            self.circleView.sunsetImageView.alpha = 0.5
                            self.backgroundImageView.alpha = 1
                        }) {
                            _ in self.circleView.start()
                            self.placeholderImageView.image = self.backgroundImageView.image
                        }
                    }
                } catch {
                    print("Error:", error)
                }
            }
        }.resume()
    }
}
