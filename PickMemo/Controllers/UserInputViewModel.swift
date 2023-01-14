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
    
    @Published var categoryInput: String = "" {
        didSet {
            print("변경된 category: \(categoryInput)")
        }
    }
    
    @Published var memoTextInput: String = "" {
        didSet {
            print("변경된 memo: \(memoTextInput)")
        }
    }
    
    lazy var isValidInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($categoryInput, $memoTextInput)
        .map({ (category: String, memo: String) in
            if category == "" || memo == "" {
                return false
            } else {
                return true
            }
        })
        .print()
        .eraseToAnyPublisher()
}
