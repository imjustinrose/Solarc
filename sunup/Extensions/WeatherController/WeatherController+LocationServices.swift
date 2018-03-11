//
//  WeatherController+LocationServices.swift
//  sunup
//
//  Created by Justin Rose on 3/10/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import CoreLocation

extension WeatherController {
    func checkLocationServicesStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                locationDisabledLabel.isHidden = true
            case .denied, .notDetermined, .restricted:
                locationDisabledLabel.isHidden = false
            }
        } else {
            locationDisabledLabel.isHidden = false
        }
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        checkLocationServicesStatus()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleForegroundAppearance), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackgroundAppearance), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func handleForegroundAppearance() {
        locationManager.startUpdatingLocation()
        checkLocationServicesStatus()
    }
    
    @objc private func handleBackgroundAppearance() {
        circleView.sunAngleTimer?.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServicesStatus()
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        getWeatherData()
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
