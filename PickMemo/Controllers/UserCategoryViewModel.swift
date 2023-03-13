//
//  UserCategoryViewModel.swift
//  PickMemo
//
//  Created by Kant on 2023/03/13.
//

import Foundation
import Combine

class UserCategoryViewModel {
    
    @Published var emojiInput: String = "" {
        didSet {
            print("변경된 emoji: \(emojiInput)")
        }
    }
    
    @Published var categoryInput: String = "" {
        didSet {
            print("변경된 category: \(categoryInput)")
        }
    }
    
    lazy var isValidInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emojiInput, $categoryInput)
        .map({ (emoji: String, category: String) in
            if emoji == "" || category == "" {
                return false
            } else {
                return true
            }
        })
        .print()
        .eraseToAnyPublisher()
}
