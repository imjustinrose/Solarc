//
//  WeatherController.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController {
    
    // MARK: Interface Elements
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
    
    lazy var weatherDataView: WeatherDataView = {
        let view = WeatherDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var circleView: CircleView = {
        let circleView = CircleView()
        circleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        circleView.delegate = self
        return circleView
    }()
    
    let locationDisabledLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please enable location services so we can determine when the sun rises and sets."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
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
    
    // MARK: Location Manager
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.distanceFilter = kCLDistanceFilterNone
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        lm.delegate = self
        return lm
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocationManager()
        setupObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


