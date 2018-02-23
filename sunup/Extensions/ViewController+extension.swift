//
//  ViewController+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - UIStatusBarStyle
extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Obtaining sunrise/set data
extension ViewController {
    func getSunData() {
        guard let longitude = locationManager.location?.coordinate.longitude,
            let latitude = locationManager.location?.coordinate.latitude,
            let url = buildURL(latitude: latitude, longitude: longitude) else { return }
        
        self.backgroundImageView.alpha = 0
        
        URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
            if let data = data {
                
                do {
                    let json = try JSONDecoder().decode(Location.self, from: data)
                    
                    let df = DateFormatter()
                    df.dateFormat = self.circleView.militaryTime ? DateFormat.military : DateFormat.meridiem
                    
                    let sunrise = df.string(from: Date(timeIntervalSince1970: TimeInterval(json.sys.sunrise)))
                    let sunset = df.string(from: Date(timeIntervalSince1970: TimeInterval(json.sys.sunset)))
                    
                    self.circleView.sun = Sun(rise: sunrise, set: sunset)
                    
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(named: Date().getTimeOfDay(sunrise: sunrise, sunset: sunset).rawValue)
                        
                        self.circleView.setNeedsDisplay()
                        self.sunriseTimeLabel.text = sunrise
                        self.sunsetTimeLabel.text = sunset
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            self.sunriseTimeLabel.alpha = 0.5
                            self.sunsetTimeLabel.alpha = 0.5
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

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        getSunData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
    
    func buildURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.OpenWeather.scheme
        components.host = Constants.OpenWeather.host
        components.path = Constants.OpenWeather.path
        
        let latitudeQueryItem = URLQueryItem(name: Constants.OpenWeatherParameterKeys.latitude, value: String(latitude))
        let longitudeQueryItem = URLQueryItem(name: Constants.OpenWeatherParameterKeys.longitude, value: String(longitude))
        let appIDQueryItem = URLQueryItem(name: Constants.OpenWeatherParameterKeys.appid, value: Constants.OpenWeather.appid)
        
        components.queryItems = [latitudeQueryItem, longitudeQueryItem, appIDQueryItem]
        
        return components.url
    }
}

// MARK: - CircleViewDelegate
extension ViewController: CircleViewDelegate {
    func didChangeTimeFormat(_ militaryTime: Bool) {

        UIView.transition(with: self.sunsetTimeLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in

                            self.sunsetTimeLabel.text = militaryTime ? self.sunsetTimeLabel.text?.military : self.sunsetTimeLabel.text?.meridiem
        })

        UIView.transition(with: self.sunriseTimeLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in

                            self.sunriseTimeLabel.text = militaryTime ? self.sunriseTimeLabel.text?.military : self.sunriseTimeLabel.text?.meridiem
        })
    }
}

// MARK: - ScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y * 0.25
        
        let height = view.bounds.height
        
        let backRangeHeight = backRange.bounds.height
        let backRangeOrigin = (height - backRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.backRange
        
        let middleRangeHeight = backRange.bounds.height
        let middleRangeOrigin = (height - middleRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.middleRange
        
        let frontRangeHeight = backRange.bounds.height
        let frontRangeOrigin = (height - frontRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.frontRange
        
        let isScrollingDown = offsetY < 0
        
        UIView.animate(withDuration: 0.01) {
            self.frontRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY * 0.7) + frontRangeOrigin
            self.middleRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY) + middleRangeOrigin
            self.backRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY * 1.5) + backRangeOrigin
        }
        
    }
}
