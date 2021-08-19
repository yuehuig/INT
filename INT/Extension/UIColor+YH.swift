//
//  UIColor+YH.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit

public extension UIColor {
    @nonobjc static func hexa(_ value: UInt32) -> UIColor {
        let a = CGFloat((value & 0xFF000000) >> 24) / 255.0
        let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((value & 0xFF00) >> 8) / 255.0
        let b = CGFloat((value & 0xFF)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    @nonobjc static func hex(_ value: UInt32) -> UIColor {
        let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((value & 0xFF00) >> 8) / 255.0
        let b = CGFloat((value & 0xFF)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    var hexString: String {
        guard let components = self.cgColor.components else { return "000000" }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    /// 16进制颜色转换
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        }
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.count != 6 {
            return clear
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = (cString as NSString).substring(with: NSMakeRange(2, 2))
        let bString = (cString as NSString).substring(from: 4)
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /// 随机色
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                       green: CGFloat(arc4random_uniform(256)) / 255.0,
                       blue: CGFloat(arc4random_uniform(256)) / 255.0,
                       alpha: 1.0)
    }
}
