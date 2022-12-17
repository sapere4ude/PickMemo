//
//  UIButton+Extension.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
