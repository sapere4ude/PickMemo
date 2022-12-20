//
//  SelectCategoryViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/18.
//

import Foundation
import Combine

class SelectCategoryViewModel {
//    @Published var selectCategory: String = "" {
//        didSet {
//            print("선택된 카테고리: \(selectCategory)")
//        }
//    }
    
    @Published var selectCategory: SelectCategory? = nil {
        didSet {
            print("SelectCategoryViewModel 선택된 카테고리: \(selectCategory?.category)")
        }
    }
    
    var currentCount = CurrentValueSubject<Int, Never>(0)

    var dismissAction = PassthroughSubject<Void, Never>()
    
    
    //var inputAction = PassthroughSubject<Action, Never>()
    
    // stateless
    // stateful
    var subscriptions = Set<AnyCancellable>()
    
    @Published var someResult = [String]()
    
    init(){
//        inputAction
//            .sink { [weak self] action in
//                guard let self = self else { return }
//                switch action{
//                case .add:
//                    self.handleAdd()
//                default: break
//                }
//            }.store(in: &subscriptions)
        
    }
    
    fileprivate func handleAdd(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        someResult = ["ㄴㅇㅇㅇ", "ㅇㄹㅇㄹ"]
    }
    
}
