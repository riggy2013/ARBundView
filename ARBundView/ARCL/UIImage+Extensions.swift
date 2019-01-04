//
//  UIImage+Extensions.swift
//  ARBundView
//
//  Created by David Peng on 2019/1/4.
//  Copyright © 2019 David Peng. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    class func imageWithLabel(_ label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
