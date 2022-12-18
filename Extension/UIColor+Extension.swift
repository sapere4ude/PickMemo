//
//  UIColor+Extension.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit

extension UIColor {
    static var blackThree: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    static var green1: UIColor {
        return UIColor(hex: "05d686")
    }

}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
