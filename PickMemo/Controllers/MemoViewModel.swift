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
        case modify
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    var inputAction = PassthroughSubject<Action, Never>()
    var test = PassthroughSubject<[Memo], Never>()
    
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
                case .modify:
                    self.modifyMemo()
                case .fetch:
                    self.fetchMemo()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMemo(_ userInputVM: UserInputViewModel){
        // userInputVM의 데이터를 가져와야한다.
//        let memo = Memo(title: userInputVM?.titleTextInput, memo: userInputVM?.memoTextInput, category: userInputVM?.categoryInput)
        
         let memo = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput)
        
        //let memo = Memo(title: "title test", memo: "memo test", category: "category test")
        
        //var fetchedMemos : [Memo] = []
        
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        
        // 가져온 데이터에 새 메모 추가하기
        memoList.append(memo)
        
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMemoList(with: memoList)
        
        test.send(memoList)
        
        //self.fetchMemo()
        
        //print(#fileID, #function, #line, "kant test \(userInputVM?.$memoTextInput)")
    }
    
    fileprivate func deleteMemo(_ index: Int){
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        memoList.remove(at: index)
        UserDefaultsManager.shared.setMemoList(with: memoList)
        self.fetchMemo()
    }
    
    fileprivate func resetMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        // someResult = ["ㄴㅇㅇㅇ", "ㅇㄹㅇㄹ"]
    }
    
    fileprivate func modifyMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        // someResult = ["ㄴㅇㅇㅇ", "ㅇㄹㅇㄹ"]
    }
    
    fileprivate func fetchMemo() -> [Memo] {
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        print(#fileID, #function, #line, "kant test, fetchedMemos:\(memoList)")
        return memoList
    }
    
}
