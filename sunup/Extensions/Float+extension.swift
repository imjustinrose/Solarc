//
//  Float+extension.swift
//  sunup
//
//  Created by Justin Rose on 2/7/18.
//  Copyright © 2018 justncode, LLC. All rights reserved.
//

import UIKit

extension Float {
    var angle: Float { return self / 12 * .pi }
    var hundredths: Float { return self / 60 }
    var cgFloat: CGFloat { return CGFloat(self) }
}
