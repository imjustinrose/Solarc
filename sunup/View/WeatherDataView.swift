//
//  WeatherDataView.swift
//  sunup
//
//  Created by Justin Rose on 3/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

class WeatherDataView: UIView {
    
    var onSelection: ((Int) -> Void)?
    
    let temperatureButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "temperature_normal"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "temperature_highlighted"), for: UIControlState.highlighted)
        button.setImage(#imageLiteral(resourceName: "temperature_highlighted"), for: UIControlState.selected)
        button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let humidityImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "humidity_normal"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "humidity_highlighted"), for: UIControlState.highlighted)
        button.setImage(#imageLiteral(resourceName: "humidity_highlighted"), for: UIControlState.selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let windImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "wind_normal"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "wind_highlighted"), for: UIControlState.highlighted)
        button.setImage(#imageLiteral(resourceName: "wind_highlighted"), for: UIControlState.selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let pressureImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pressure_normal"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "pressure_highlighted"), for: UIControlState.highlighted)
        button.setImage(#imageLiteral(resourceName: "pressure_highlighted"), for: UIControlState.selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [temperatureButton, humidityImageView, windImageView, pressureImageView])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 24
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        setupTextLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        stackView.anchor(top: (anchor: topAnchor, constant: 0),
                         leading: (anchor: leadingAnchor, constant: 0),
                         trailing: (anchor: trailingAnchor, constant: 0))
    }
    
    func setupTextLabel() {
        addSubview(textLabel)
        
        textLabel.anchor(top: (anchor: stackView.bottomAnchor, constant: 0),
                         leading: (anchor: leadingAnchor, constant: 0),
                         bottom: (anchor: bottomAnchor, constant: 0),
                         trailing: (anchor: trailingAnchor, constant: 0))
    }
    
    // MARK: - Actions
    @objc private func handleButtonPressed(_ sender: UIButton) {
        for case let (index, button as UIButton) in stackView.subviews.enumerated() {
            
            
            if sender == button {
                button.isSelected = !button.isSelected
                onSelection?(button.isSelected == false ? -1 : index)
            } else {
                button.isSelected  = false
            }
        }
    }
    
}
