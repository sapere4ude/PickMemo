//
//  UserCategoryViewModel.swift
//  PickMemo
//
//  Created by Kant on 2023/03/13.
//

import Foundation
import Combine

struct UserCategory: Codable {
    var categoryIcon: String = ""
    var categoryTitle: String = ""
}

class UserCategoryViewModel {
    
    @Published var selectCategory: UserCategory? = nil {
        didSet {
            print("SelectCategoryViewModel 선택된 카테고리: \(selectCategory)")
        }
    }
    
    @Published var categoryList:[UserCategory] = [UserCategory(categoryIcon: "❤️", categoryTitle: "맛집"),
                                                        UserCategory(categoryIcon: "☕️", categoryTitle: "카페"),
                                                        UserCategory(categoryIcon: "🏖️", categoryTitle: "여행"),
                                                        UserCategory(categoryIcon: "🧘🏻", categoryTitle: "휴식"),
                                                        UserCategory(categoryIcon: "📌", categoryTitle: "기록")]
    
    @Published var emojiInput: String = "🙂" {
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
    
    // 카테고리 중복은 우선 보류하기
//    lazy var isDuplicate: AnyPublisher<Bool, Never> = Publishers
//        .CombineLatest($emojiInput, $categoryInput)
//        .map({ (emoji: String, categoryInput: String) -> Bool in
//            for category in self.categoryList ?? [] {
//                if category.categoryIcon == emoji || category.categoryTitle == categoryInput {
//                    return true
//                }
//            }
//            return false
//        })
//        .print()
//        .eraseToAnyPublisher()
    
    
    // TODO: - 카테고리 관련 비즈니스 모델 만들기
    enum Action {
        case create
        case fetch
    }

    var subscriptions = Set<AnyCancellable>()
//
    var inputAction = PassthroughSubject<Action, Never>()
    var modifyAction = PassthroughSubject<Void, Never>()
    var dismissAction = PassthroughSubject<Void, Never>() // 메모 생성 완료 후 첫 뷰컨으로 이동하기 위해 사용
//
    init() {
        inputAction
            .print()
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .create:
                    self.create()
                case .fetch:
                    self.fetch()
                }
            }.store(in: &subscriptions)
        
        fetch()
    }
    
    fileprivate func create() {
        let userCategory = UserCategory(categoryIcon: self.emojiInput, categoryTitle: self.categoryInput)
        
        if var tempCategoryList = UserDefaultsManager.shared.getCategoryList() {
            tempCategoryList.append(userCategory)
            self.categoryList = tempCategoryList
        } else {
            self.categoryList.append(userCategory)
        }
        
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setCategoryList(with: categoryList)
        
        // TODO: - 카테고리 항목에 업데이트 된 항목이 나올 수 있게 수정필요
    }
    
    // TODO: - 유저가 만들어둔 카테고리
    fileprivate func fetch() -> [UserCategory] {
        //categoryList = UserDefaultsManager.shared.getCategoryList() ?? []
        
        if let savedCategoryList = UserDefaultsManager.shared.getCategoryList() {
         categoryList = savedCategoryList
        }
        
        print(#fileID, #function, #line, "kant test, fetchedCategory:\(categoryList)")
        return categoryList
    }
}
