//
//  EditMemoViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/24.
//

import Foundation
import Combine

class EditMemoViewModel {
    
    @Published var memo: Memo
    
    var userInputVM: UserInputViewModel?
    
    var subscriptions = Set<AnyCancellable>()
    
    var selectedMemo : Memo?
    
    init(userInputVM: UserInputViewModel?, selectedMemo: Memo) {
        
        self.memo = Memo(title: userInputVM?.titleTextInput, memo: userInputVM?.memoTextInput, category: userInputVM?.categoryInput, lat: selectedMemo.lat, lng: selectedMemo.lng)
    }
    
    func editMemo(_ memo: Memo, selectedMemo: Memo) {
        var memoList = UserDefaultsManager.shared.getMemoList() ?? []
        if let foundIndex = memoList.firstIndex(where: { $0.uuid == selectedMemo.uuid }) {
            memoList[foundIndex] = memo
            UserDefaultsManager.shared.setMemoList(with: memoList)
        }
        
        
    }
}
