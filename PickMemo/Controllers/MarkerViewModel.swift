//
//  MarkerViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation
import Combine

class MarkerViewModel {
    @Published var markerList:[Marker] = [Marker]()
    var mark: Marker?
    
    enum Action {
        case create(_ marker: Marker)
        case search
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    var inputAction = PassthroughSubject<Action, Never>()
    
    init(markerList: [Marker]) {
        self.markerList = markerList
        
        inputAction
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .create(let marker):
                    self.createMarker(marker)
                case .search:
                    print("test")
                case .fetch:
                    print("fetch")
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMarker(_ marker: Marker) {
//         let memo = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput)
//
//        memoList = UserDefaultsManager.shared.getMemoList() ?? []
//
//        memoList.append(memo)
//
//        // 업데이트 된 데이터 저장하기
//        UserDefaultsManager.shared.setMemoList(with: memoList)
        
        markerList.append(marker)
    }
}
