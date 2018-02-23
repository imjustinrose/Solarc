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
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        return label
    }()
    
    let sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
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
        
        sunriseImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                leading: (anchor: view.leadingAnchor, constant: 0),
                                bottom: (anchor: view.centerYAnchor, constant: 0),
                                trailing: (anchor: view.trailingAnchor, constant: 0))
        
        sunriseTimeLabel.anchor(top: (anchor: view.centerYAnchor, constant: 0),
                                leading: (anchor: view.leadingAnchor, constant: 0),
                                bottom: (anchor: view.bottomAnchor, constant: 0),
                                trailing: (anchor: view.trailingAnchor, constant: 0))
        
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
        
        sunsetImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                               leading: (anchor: view.leadingAnchor, constant: 0),
                               bottom: (anchor: view.centerYAnchor, constant: 0),
                               trailing: (anchor: view.trailingAnchor, constant: 0))
        
        sunsetTimeLabel.anchor(top: (anchor: view.centerYAnchor, constant: 0),
                               leading: (anchor: view.leadingAnchor, constant: 0),
                               bottom: (anchor: view.bottomAnchor, constant: 0),
                               trailing: (anchor: view.trailingAnchor, constant: 0))
        
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
        circleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        circleView.delegate = self
        return circleView
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backRange: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "back_range"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let middleRange: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "middle_range"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let frontRange: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "front_range"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        // circleView.currentTimeTimer?.invalidate()
        circleView.sunAngleTimer?.invalidate()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCircleView()
        setupMountainRanges()
        setupScrollView()
        
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

// MARK: Interface Setup
extension ViewController {
    func setupMountainRanges() {
        _ = [backRange, middleRange, frontRange].map { view.addSubview($0) }
        
        backRange.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        backRange.anchor(leading: (anchor: view.leadingAnchor, constant: 0),
                         bottom: (anchor: view.bottomAnchor, constant: view.bounds.height * Constants.MountainRangeOffset.backRange),
                         trailing: (anchor: view.trailingAnchor, constant: 0))
        
        
        middleRange.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        middleRange.anchor(leading: (anchor: view.leadingAnchor, constant: 0),
                           bottom: (anchor: view.bottomAnchor, constant: view.bounds.height * Constants.MountainRangeOffset.middleRange),
                           trailing: (anchor: view.trailingAnchor, constant: 0))
        
        frontRange.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        frontRange.anchor(leading: (anchor: view.leadingAnchor, constant: 0),
                          bottom: (anchor: view.bottomAnchor, constant: view.bounds.height * Constants.MountainRangeOffset.frontRange),
                          trailing: (anchor: view.trailingAnchor, constant: 0))
    }
    
    func setupCircleView() {
        view.addSubview(placeholderImageView)
        view.addSubview(backgroundImageView)
        view.addSubview(circleView)
        view.addSubview(stackView)
        
        placeholderImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                    leading: (anchor: view.leadingAnchor, constant: 0),
                                    bottom: (anchor: view.bottomAnchor, constant: 0),
                                    trailing: (anchor: view.trailingAnchor, constant: 0))
        
        backgroundImageView.anchor(top: (anchor: view.topAnchor, constant: 0),
                                   leading: (anchor: view.leadingAnchor, constant: 0),
                                   bottom: (anchor: view.bottomAnchor, constant: 0),
                                   trailing: (anchor: view.trailingAnchor, constant: 0))
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.15).isActive = true
        stackView.anchor(leading: (anchor: view.leadingAnchor, constant: 0),
                         bottom: (anchor: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
                         trailing: (anchor: view.trailingAnchor, constant: 0))
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(top: (anchor: view.centerYAnchor, constant: 0),
                          leading: (anchor: view.leadingAnchor, constant: 0),
                          bottom: (anchor: view.bottomAnchor, constant: 0),
                          trailing: (anchor: view.trailingAnchor, constant: 0))
        
        scrollView.addSubview(containerView)
        containerView.anchor(top: (anchor: scrollView.topAnchor, constant: 0),
                             leading: (anchor: scrollView.leadingAnchor, constant: 0),
                             bottom: (anchor: scrollView.bottomAnchor, constant: -(view.bounds.height / 2) - 10),
                             trailing: (anchor: scrollView.trailingAnchor, constant: 0))
    }
}
