//
//  UserInputViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import Foundation
import Combine

class UserInputViewModel {
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
    
    @Published var categoryInput: String = "" {
        didSet {
            print("변경된 category: \(categoryInput)")
        }
    }
    
    lazy var isValidInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest3($titleTextInput, $categoryInput, $memoTextInput)
        .map({ (title: String, memo: String, category: String) in
            if title == "" || memo == "" || category == "" {
                return false
            } else {
                return true
            }
        })
        .print()
        .eraseToAnyPublisher()
}
