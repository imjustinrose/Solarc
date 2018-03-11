//
//  UIView+anchors.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func equalHeight(with width: (dimension: NSLayoutDimension, multiplier: CGFloat), multiplier: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: width.dimension, multiplier: width.multiplier),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier)
        ])
    }
    
    func center(in view: UIView) {
        centerHorizontally(in: view)
        centerVertically(in: view)
    }
    
    func centerHorizontally(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func centerVertically(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func anchor(top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top.anchor, constant: top.constant),
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant),
            trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
    
    func anchor(top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            topAnchor.constraint(equalTo: top.anchor, constant: top.constant),
            trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
    
    func anchor(leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant),
            trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
    
    func anchor(leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
    
    func anchor(top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top.anchor, constant: top.constant),
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant)
        ])
    }
    
    func anchor(top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top.anchor, constant: top.constant),
            bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant)
        ])
    }
}
