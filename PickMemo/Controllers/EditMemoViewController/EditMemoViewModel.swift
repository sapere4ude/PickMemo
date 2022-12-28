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
    
    init(userInputVM: UserInputViewModel?, indexPath: IndexPath?) {
        
        self.memo = Memo(title: userInputVM?.titleTextInput, memo: userInputVM?.memoTextInput, category: userInputVM?.categoryInput)
        
        
        //self.editMemo(self.memo, indexPath: indexPath)
    }
    
    func editMemo(_ memo: Memo, indexPath: IndexPath) {
        var memoList = UserDefaultsManager.shared.getMemoList() ?? []
        memoList[indexPath.row] = memo
        UserDefaultsManager.shared.setMemoList(with: memoList)
    }
}
