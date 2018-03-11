//
//  SunTimeswift
//  sunup
//
//  Created by Justin Rose on 2/23/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

class SunTimeView: UIView {
    
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
        sunriseImageView.alpha = 1
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
        sunsetImageView.alpha = 1
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        addSubview(stackView)
        
        stackView.anchor(top: (anchor: topAnchor, constant: 0),
                         leading: (anchor: leadingAnchor, constant: 0),
                         bottom: (anchor: bottomAnchor, constant: 0),
                         trailing: (anchor: trailingAnchor, constant: 0))
    }
}
