//
//  UIColor.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            }

    static let mainBlue = UIColor(red: 0, green: 0.515, blue: 0.887, alpha: 1)
    static let lightBlue = UIColor(red: 0.512, green: 0.707, blue: 1, alpha: 1)
}
