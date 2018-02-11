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
            
            endAngle = 3 * .pi + difference.angle
        }
    }
    
    /// The current time display.
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.text = dateFormatter.string(from: Date())
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTimeTapped)))
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
    private var endAngle: Float = 3 * .pi
    
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
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sunrise_cloud"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// The view that covers up `endAngle` location
    var sunsetImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sunset_cloud"))
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// Begins the animation
    func start(_ duration: CFTimeInterval = 2.0) {
        guard let sun = sun else { return }
        
        let rise = sun.rise.convertToTimeDecimal.angle
        let set = Date().current.convertToTimeDecimal.angle
        let difference = startAngle + (set - rise)
        
        let moveableViewPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle.cgFloat, endAngle: difference.cgFloat, clockwise: true).cgPath
        let pathAnimation = CAKeyframeAnimation(keyPath: Constants.CAKeyframeAnimation.positionKeyPath)
        
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.duration = duration
        pathAnimation.path = moveableViewPath
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        
        view.layer.add(pathAnimation, forKey: Constants.CAKeyframeAnimation.arcKey)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        arcColor.withAlphaComponent(0.1).set()
        
        context.addPath(path)
        
        view.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        view.backgroundColor = color
        view.layer.cornerRadius = view.bounds.height / 2
        view.center.y = center.y
        view.center.x = center.x - radius
        
        sunriseImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.width * 2)
        sunriseImageView.alpha = 0.5
        sunriseImageView.center.y = view.center.y
        sunriseImageView.center.x = view.center.x
        
        sunsetImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.width * 2)
        sunsetImageView.center = CGPoint(x: center.x + radius * cos(endAngle.cgFloat), y: center.y + radius * sin(endAngle.cgFloat))
        
        addSubview(view)
        addSubview(sunriseImageView)
        addSubview(sunsetImageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
            self.dateFormatter.dateFormat = self.militaryTime ? DateFormat.military : DateFormat.meridiem
            self.timeLabel.text = self.dateFormatter.string(from: Date())
        }
        
        addSubview(timeLabel)
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTimeTapped() {
        militaryTime = !militaryTime
        UserDefaults.standard.set(militaryTime, forKey: Constants.isMilitaryTime)
        
        dateFormatter.dateFormat = militaryTime ? DateFormat.military : DateFormat.meridiem
        
        UIView.transition(with: timeLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            
                            self.timeLabel.text = self.dateFormatter.string(from: Date())
                            self.delegate?.didChangeTimeFormat(self.militaryTime)
        })
    }
    
}
