//
//  ViewController.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    lazy var sunTimeView: SunTimeView = {
        let view = SunTimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mountainRangeView: MountainRangeView = {
        let view = MountainRangeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollView.delegate = self
        return view
    }()
    
    lazy var circleView: CircleView = {
        let circleView = CircleView()
        circleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        circleView.delegate = self
        return circleView
    }()
    
    // MARK: Location Manager
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.distanceFilter = kCLDistanceFilterNone
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        lm.delegate = self
        return lm
    }()
    
    // MARK: Interface Elements
    var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sunrise_bg"))
        imageView.alpha = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "night_bg"))
        imageView.alpha = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCircleView()
        setupSunTimeView()
        setupMountainRangeView()
        setupLocationManager()
        setupObserver()
        
        _ = [circleView.timeLabel, sunTimeView.sunriseTimeLabel, sunTimeView.sunsetTimeLabel].map {
            
            $0.text = circleView.militaryTime ? $0.text?.military : $0.text?.meridiem
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Location Manager
extension ViewController {
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleForegroundAppearance), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackgroundAppearance), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func handleForegroundAppearance() {
        locationManager.startUpdatingLocation()
    }
    
    @objc private func handleBackgroundAppearance() {
        circleView.sunAngleTimer?.invalidate()
    }
}

// MARK: Interface Setup
extension ViewController {
    
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
