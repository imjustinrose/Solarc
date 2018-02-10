//
//  UIView+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/9/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, trailing: NSLayoutXAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: top),
            self.leadingAnchor.constraint(equalTo: leading),
            self.bottomAnchor.constraint(equalTo: bottom),
            self.trailingAnchor.constraint(equalTo: trailing)
        ])
    }
}
