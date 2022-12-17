//
//  UITextView+Extension.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import Combine

extension UITextView {
    var textViewInputPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
