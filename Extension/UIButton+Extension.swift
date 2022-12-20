//
//  UIButton+Extension.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import Combine

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .green1
        }
        set {
            backgroundColor = newValue ? .green1 : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .white : .white, for: .normal)
        }
    }
}
