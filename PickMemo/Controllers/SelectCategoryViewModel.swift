//
//  SelectCategoryViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/18.
//

import Foundation
import Combine

class SelectCategoryViewModel {
    @Published var selectCategory: String = "" {
        didSet {
            print("선택된 카테고리: \(selectCategory)")
        }
    }
}
