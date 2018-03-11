//
//  UILabel+DynamicSize.swift
//  sunup
//
//  Created by Justin Rose on 3/11/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension UILabel {
    func scaleWithDefaultFont(of size: CGFloat, minimumFont: CGFloat, baselineAdjustment: UIBaselineAdjustment) {
        self.baselineAdjustment = baselineAdjustment
        self.minimumScaleFactor = minimumFont / size
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
    }
}
