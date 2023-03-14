//
//  UserCategoryViewModel.swift
//  PickMemo
//
//  Created by Kant on 2023/03/13.
//

import Foundation
import Combine

struct UserCategoryModel {
    var categoryIcon: String = ""
    var categoryTitle: String = ""
}

class UserCategoryViewModel {
    
    @Published var categoryList:[UserCategoryModel]? = [UserCategoryModel(categoryIcon: "❤️", categoryTitle: "맛집"), UserCategoryModel(categoryIcon: "☕️", categoryTitle: "카페"), UserCategoryModel(categoryIcon: "🏖️", categoryTitle: "여행"), UserCategoryModel(categoryIcon: "🧘🏻", categoryTitle: "휴식"), UserCategoryModel(categoryIcon: "📌", categoryTitle: "기록")]
    
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
    
    lazy var avoidDuplicatesPublisher: AnyPublisher<Bool, Never> = {
        subject.handleEvents(receiveOutput: { [weak self] element in
            guard let self = self else {
                return
            }
            guard !self.array.contains(element) else {
                return
            }
            self.array.append(element)
        })
        .map { _ in true }
        .catch { _ in Just(false) }
        .eraseToAnyPublisher()
    }()
    
    lazy var avoidDup: AnyPublisher<Bool, Never> = {
        
    }()
    
    // TODO: - 카테고리 관련 비즈니스 모델 만들기
    @Published var memoList:[Memo] = [Memo]()
    var userInputVM: UserInputViewModel?
    
    enum Action {
        case create(_ userInputVM: UserInputViewModel, _ selectedMarker: Marker)
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    var inputAction = PassthroughSubject<Action, Never>()
    var modifyAction = PassthroughSubject<Void, Never>()
    
    init(userInputVM: UserInputViewModel?) {
        self.userInputVM = userInputVM
        
        inputAction
            .print()
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .create(let userInputVM, let selectedMarker):
                    self.createMemo(userInputVM, selectedMarker)
                case .fetch:
                    self.fetchMemo()
                }
            }.store(in: &subscriptions)
        fetchMemo()
    }
}
