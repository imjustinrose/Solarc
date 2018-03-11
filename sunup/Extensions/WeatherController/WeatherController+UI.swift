//
//  WeatherController+UI.swift
//  sunup
//
//  Created by Justin Rose on 3/10/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension WeatherController {
    
    func setupUI() {
        setupCircleView()
        setupSunTimeView()
        setupMountainRangeView()
        setupWeatherDataView()
        setupLocationDisabledLabel()
        
        _ = [sunTimeView.sunriseTimeLabel, sunTimeView.sunsetTimeLabel].map {
            $0.text = circleView.militaryTime ? $0.text?.military : $0.text?.meridiem
        }
    }
    
    func setupLocationDisabledLabel() {
        locationDisabledLabel.isHidden = true
        view.addSubview(locationDisabledLabel)
        
        locationDisabledLabel.centerHorizontally(in: view)
        locationDisabledLabel.anchor(top: (anchor: view.topAnchor, constant: view.bounds.height * 0.1),
                                     leading: (anchor: view.leadingAnchor, constant: 24),
                                     trailing: (anchor: view.trailingAnchor, constant: -24))
    }
    
    func setupSunTimeView() {
        view.addSubview(sunTimeView)
        
        sunTimeView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.15).isActive = true
        sunTimeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sunTimeView.anchor(leading: (anchor: view.leadingAnchor, constant: 0),
                           bottom: (anchor: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
                           trailing: (anchor: view.trailingAnchor, constant: 0))
        
    }
    
    func setupMountainRangeView() {
        view.addSubview(mountainRangeView)
        
        mountainRangeView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                 leading: (anchor: view.leadingAnchor, constant: 0),
                                 bottom: (anchor: view.bottomAnchor, constant: 1),
                                 trailing: (anchor: view.trailingAnchor, constant: 0))
    }
    
    func setupWeatherDataView() {
        view.addSubview(weatherDataView)
        
        weatherDataView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        weatherDataView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        weatherDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.0375).isActive = true
        weatherDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupCircleView() {
        view.addSubview(placeholderImageView)
        view.addSubview(backgroundImageView)
        view.addSubview(circleView)
        
        placeholderImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                    leading: (anchor: view.leadingAnchor, constant: 0),
                                    bottom: (anchor: view.bottomAnchor, constant: 0),
                                    trailing: (anchor: view.trailingAnchor, constant: 0))
        
        backgroundImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                   leading: (anchor: view.leadingAnchor, constant: 0),
                                   bottom: (anchor: view.bottomAnchor, constant: 0),
                                   trailing: (anchor: view.trailingAnchor, constant: 0))
    }
}

// MARK: - CircleViewDelegate
extension WeatherController: CircleViewDelegate {
    func didChangeTimeFormat(_ militaryTime: Bool) {
        
        UIView.transition(with: self.sunTimeView.sunsetTimeLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            
                            self.sunTimeView.sunsetTimeLabel.text = militaryTime ? self.sunTimeView.sunsetTimeLabel.text?.military : self.sunTimeView.sunsetTimeLabel.text?.meridiem
        })
        
        UIView.transition(with: self.sunTimeView.sunriseTimeLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            
                            self.sunTimeView.sunriseTimeLabel.text = militaryTime ? self.sunTimeView.sunriseTimeLabel.text?.military : self.sunTimeView.sunriseTimeLabel.text?.meridiem
        })
    }
}

// MARK: - ScrollViewDelegate
extension WeatherController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y * 0.25
        
        let height = view.bounds.height
        
        let backRangeHeight = mountainRangeView.backRange.bounds.height
        let backRangeOrigin = (height - backRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.backRange
        
        let middleRangeHeight = mountainRangeView.middleRange.bounds.height
        let middleRangeOrigin = (height - middleRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.middleRange
        
        let frontRangeHeight = mountainRangeView.frontRange.bounds.height
        let frontRangeOrigin = (height - frontRangeHeight) + view.bounds.height * Constants.MountainRangeOffset.frontRange
        
        let isScrollingDown = offsetY < 0
        
        UIView.animate(withDuration: 0.01) {
            self.mountainRangeView.frontRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY * 1.3) + frontRangeOrigin
            self.mountainRangeView.middleRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY * 0.9) + middleRangeOrigin
            self.mountainRangeView.backRange.frame.origin.y = (isScrollingDown ? -offsetY : -offsetY * 0.5) + backRangeOrigin
        }
    }
}
