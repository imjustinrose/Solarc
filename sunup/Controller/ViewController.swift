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
    
    let sunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var sunriseView: UIView = {
        let view = UIView()
        
        let sunriseImageView = UIImageView(image: #imageLiteral(resourceName: "sunrise_cloud"))
        sunriseImageView.alpha = 0.5
        sunriseImageView.translatesAutoresizingMaskIntoConstraints = false
        sunriseImageView.contentMode = .scaleAspectFit
        
        view.addSubview(sunriseImageView)
        view.addSubview(sunriseTimeLabel)
        
        sunriseImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor)
        sunriseTimeLabel.anchor(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        return view
    }()
    
    lazy var sunsetView: UIView = {
        let view = UIView()
        
        let sunsetImageView = UIImageView(image: #imageLiteral(resourceName: "sunset_cloud"))
        sunsetImageView.alpha = 0.5
        sunsetImageView.translatesAutoresizingMaskIntoConstraints = false
        sunsetImageView.contentMode = .scaleAspectFit
        
        view.addSubview(sunsetImageView)
        view.addSubview(sunsetTimeLabel)
        
        sunsetImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor)
        sunsetTimeLabel.anchor(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sunriseView, sunsetView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var circleView: CircleView = {
        let circleView = CircleView()
        circleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
        circleView.delegate = self
        return circleView
    }()
    
    func setupCircleView() {
        view.addSubview(placeholderImageView)
        view.addSubview(backgroundImageView)
        view.addSubview(circleView)
        circleView.addSubview(stackView)
        
        placeholderImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        NSLayoutConstraint.activate([
    
            stackView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: circleView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleForegroundAppearance), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleForegroundAppearance() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCircleView()
        setupLocationManager()
        setupObserver()
        
        _ = [circleView.timeLabel, sunriseTimeLabel, sunsetTimeLabel].map {
            
            $0.text = circleView.militaryTime ? $0.text?.military : $0.text?.meridiem
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
