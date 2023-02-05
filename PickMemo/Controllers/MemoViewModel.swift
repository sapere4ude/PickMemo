//
//  MemoViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/19.
//

import Foundation
import Combine

class MemoViewModel {
    
    @Published var memoList:[Memo] = [Memo]()
    var userInputVM: UserInputViewModel?
    
    enum Action {
        case create(_ userInputVM: UserInputViewModel)
        case delete(_ index: Int)
        case reset
        case modify(_ userInputVM: UserInputViewModel, indexPathRow: Int)
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
                case .create(let userInputVM):
                    self.createMemo(userInputVM)
                case .delete(let index):
                    self.deleteMemo(index)
                case .reset:
                    self.resetMemo()
                case .modify(let userInputVM, let index):
                    self.modifyMemo(userInputVM, indexPathRow: index)
                case .fetch:
                    self.fetchMemo()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMemo(_ userInputVM: UserInputViewModel) {
         let memo = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput)
        
        var tempMemoList = UserDefaultsManager.shared.getMemoList() ?? []
        tempMemoList.append(memo)
        self.memoList = tempMemoList
        
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMemoList(with: memoList)
    }
    
    fileprivate func deleteMemo(_ index: Int) {
        // TODO: - 메모 삭제했을때 마커 다시 그려주는 로직 태워야함
        var tempMemoList = UserDefaultsManager.shared.getMemoList() ?? []
        tempMemoList.remove(at: index)
        self.memoList = tempMemoList
        UserDefaultsManager.shared.setMemoList(with: memoList)
    }
    
    fileprivate func resetMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경 (코드테스트)
    }
    
    fileprivate func modifyMemo(_ userInputVM: UserInputViewModel, indexPathRow: Int) {
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        memoList[indexPathRow] = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput)
        UserDefaultsManager.shared.setMemoList(with: memoList)
        //self.fetchMemo()
    }
    
    fileprivate func fetchMemo() -> [Memo] {
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        print(#fileID, #function, #line, "kant test, fetchedMemos:\(memoList)")
        return memoList
    }
}
