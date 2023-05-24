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
    static let mainViewGrey = UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1)
    
    // 부제목 grey02 스케일 텍스트 컬러
    static let textGrey02 = hexStringToUIColor(hex: "#8B8B8B")
    
    // 폴리라인 컬러
    static let polylineColor = hexStringToUIColor(hex: "#005BE4")
    
    // 안심태그, 일반태그 컬러
    static let secureTagColor = hexStringToUIColor(hex: "#BBE2FF")
    static let recommendedTagColor = hexStringToUIColor(hex: "#FCDCBE")
}

// MARK: #000000 -> UIColor (hexcode to UIColor)
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
