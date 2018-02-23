//
//  MountainRangeView.swift
//  sunup
//
//  Created by Justin Rose on 2/23/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

class MountainRangeView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupMountainRanges()
        setupScrollView()
    }
    
    func setupScrollView() {
        addSubview(scrollView)
        scrollView.anchor(top: (anchor: centerYAnchor, constant: 0),
                          leading: (anchor: leadingAnchor, constant: 0),
                          bottom: (anchor: bottomAnchor, constant: 0),
                          trailing: (anchor: trailingAnchor, constant: 0))
        
        guard let superview = superview else { return }
        
        scrollView.addSubview(containerView)
        containerView.anchor(top: (anchor: scrollView.topAnchor, constant: 0),
                             leading: (anchor: scrollView.leadingAnchor, constant: 0),
                             bottom: (anchor: scrollView.bottomAnchor, constant: -(superview.bounds.height / 2) - 1),
                             trailing: (anchor: scrollView.trailingAnchor, constant: 0))
    }
    
    func setupMountainRanges() {
        _ = [backRange, middleRange, frontRange].map { addSubview($0) }
        
        guard let superview = superview else { return }
        
        backRange.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        backRange.anchor(leading: (anchor: leadingAnchor, constant: 0),
                         bottom: (anchor: bottomAnchor, constant: bounds.height * Constants.MountainRangeOffset.backRange),
                         trailing: (anchor: trailingAnchor, constant: 0))
        
        
        middleRange.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        middleRange.anchor(leading: (anchor: leadingAnchor, constant: 0),
                           bottom: (anchor: bottomAnchor, constant: superview.bounds.height * Constants.MountainRangeOffset.middleRange),
                           trailing: (anchor: trailingAnchor, constant: 0))
        
        frontRange.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        frontRange.anchor(leading: (anchor: leadingAnchor, constant: 0),
                          bottom: (anchor: bottomAnchor, constant: superview.bounds.height * Constants.MountainRangeOffset.frontRange),
                          trailing: (anchor: trailingAnchor, constant: 0))
    }
}
