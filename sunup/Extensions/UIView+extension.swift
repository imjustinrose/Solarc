//
//  UIView+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: top.anchor, constant: top.constant),
            self.leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            self.bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant),
            self.trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
    
    func anchor(leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat), bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat), trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant),
            self.bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.constant),
            self.trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.constant)
        ])
    }
}
