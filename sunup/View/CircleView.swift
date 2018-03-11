//
//  CircleView.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

protocol CircleViewDelegate {
    func didChangeTimeFormat(_ isMilitaryTime: Bool)
}

class CircleView: UIView {
    
    var delegate: CircleViewDelegate?
    
    var sun: Sun? {
        didSet {
            guard let sun = sun else { return }
            
            let difference = (sun.set).convertToTimeDecimal - (sun.rise).convertToTimeDecimal
            
            sunsetAngle = 3 * .pi + difference.angle
        }
    }
    
    /// The sun's timer.
    var sunAngleTimer: Timer?
    
    /// The current temperature display.
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 32)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.alpha = 0
        return label
    }()
    
    /// The date formatter for the current time.
    private var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = DateFormat.meridiem
        return df
    }()
    
    /// Toggle between military and meridiem times.
    var militaryTime: Bool = UserDefaults.standard.bool(forKey: Constants.isMilitaryTime)
    
    /// The color of the arc.
    private var arcColor: UIColor = .white
    
    /// The color of the movable view.
    private var color: UIColor = .white
    
    /// The starting location of the movable view (radians).
    private var startAngle: Float = .pi
    
    /// The ending location of the movable view (radians).
    private var endAngle: Float = 0
    
    /// The ending location of the movable view (radians).
    private var sunsetAngle: Float = 0
    
    /// The radius of the arc.
    private lazy var radius: CGFloat = 0.3 * min(bounds.width, bounds.height)
    
    /// The "movable view" that rotates around the arc.
    private lazy var view: UIView = {
        let view = UIView(frame: .zero)
        
        // Glow effect
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.white.cgColor
        
        return view
    }()
    
    /// The path of the drawn arc (not to be confused with the moveable view's arc).
    private lazy var path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
    
    /// The view that covers up `startAngle` location
    private var sunriseImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sunrise_cloud_outline"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// The view that covers up `endAngle` location
    var sunsetImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sunset_cloud_outline"))
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        arcColor.withAlphaComponent(0.1).set()
        
        context.addPath(path)
        
        view.frame = CGRect(x: 0, y: 0, width: 17.5, height: 17.5)
        view.backgroundColor = color
        view.layer.cornerRadius = view.bounds.height / 2
        view.center.y = center.y
        view.center.x = center.x - radius
        
        sunriseImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.width * 2)
        sunriseImageView.alpha = 0.5
        sunriseImageView.center.y = view.center.y
        sunriseImageView.center.x = view.center.x
        
        sunsetImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.width * 2)
        sunsetImageView.center = CGPoint(x: center.x + radius * cos(sunsetAngle.cgFloat), y: center.y + radius * sin(sunsetAngle.cgFloat))
        
        addSubview(view)
        addSubview(sunriseImageView)
        addSubview(sunsetImageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(temperatureLabel)
        temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CircleView {
    /// Begins in animation
    func start(_ duration: CFTimeInterval = 2.0) {
        guard let sun = sun else { return }
        
        let rise = sun.rise.convertToTimeDecimal.angle
        let current = Date().current.convertToTimeDecimal.angle
        
        endAngle = .pi + (current - rise)
        
        let moveableViewPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle.cgFloat, endAngle: endAngle.cgFloat + Float(0.01).radians.cgFloat, clockwise: true).cgPath
        let pathAnimation = CAKeyframeAnimation(keyPath: Constants.CAKeyframeAnimation.positionKeyPath)
        
        pathAnimation.delegate = self
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.duration = duration
        pathAnimation.path = moveableViewPath
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        
        view.layer.add(pathAnimation, forKey: Constants.CAKeyframeAnimation.arcKey)
    }
    
    func start(from startAngle: Float, to endAngle: Float, duration: CFTimeInterval = 2.0) {
        let moveableViewPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle.cgFloat, endAngle: endAngle.cgFloat, clockwise: true).cgPath
        let pathAnimation = CAKeyframeAnimation(keyPath: Constants.CAKeyframeAnimation.positionKeyPath)
        
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.duration = duration
        pathAnimation.path = moveableViewPath
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        
        view.layer.add(pathAnimation, forKey: Constants.CAKeyframeAnimation.arcKey)
    }
}

extension CircleView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        self.startAngle = self.endAngle
        
        sunAngleTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [unowned self] _ in

            // 1440 minutes in a day
            let degree: Float  = 360.0 / 1440

            self.startAngle = self.endAngle
            self.endAngle = self.endAngle + degree.radians

            self.start(from: self.startAngle, to: self.endAngle)
            
            
        })
    }
}
