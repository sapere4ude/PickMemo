//
//  MyViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import Foundation
import Combine

class MyViewModel {
    @Published var titleTextInput: String = "" {
        didSet {
            print("변경된 title: \(titleTextInput)")
        }
    }
    @Published var memoTextInput: String = "" {
        didSet {
            print("변경된 memo: \(memoTextInput)")
        }
    }
    
    lazy var isValidInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($titleTextInput, $memoTextInput)
        .map({ (title: String, memo: String) in
            if title == "" || memo == "" {
                return false
            } else {
                return true
            }
        })
        .print()
        .eraseToAnyPublisher()
}
