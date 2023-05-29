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
    
    // 지정컬러 (추후 이 부분 남기고 정리)
    static let blue400 = hexStringToUIColor(hex: "#3B8DED")
    static let blue500 = hexStringToUIColor(hex: "#005EE2")
    
    static let grey100 = hexStringToUIColor(hex: "#F2F2F2")
    static let grey200 = hexStringToUIColor(hex: "#DFDFDF")
    static let grey300 = hexStringToUIColor(hex: "#C1C1C1")

    static let grey400 = hexStringToUIColor(hex: "#A5A5A5")
    static let grey500 = hexStringToUIColor(hex: "#8B8B8B")
    static let grey600 = hexStringToUIColor(hex: "#6F6F6F")

    static let grey700 = hexStringToUIColor(hex: "#555555")
    static let grey800 = hexStringToUIColor(hex: "#3D3D3D")
    static let grey1900 = hexStringToUIColor(hex: "#242424")
    
    static let orange200 = hexStringToUIColor(hex: "#FFECD0")

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
