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
    let userInputVM: UserInputViewModel?
    
    enum Action {
        case create
        case delete
        case reset
        case modify
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    var inputAction = PassthroughSubject<Action, Never>()
    
    init(vm: UserInputViewModel?){
        self.userInputVM = vm
        
        inputAction
            .print()
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action{
                case .create:
                    self.createMemo()
                case .delete:
                    self.deleteMemo()
                case .reset:
                    self.resetMemo()
                case .modify:
                    self.modifyMemo()
                case .fetch:
                    self.fetchMemo()
                default:
                    break
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        
        // userInputVM의 데이터를 가져와야한다.
        let memo = Memo(title: userInputVM?.titleTextInput, memo: userInputVM?.memoTextInput, category: userInputVM?.categoryInput)
        
        var fetchedMemos : [Memo] = []
        
        fetchedMemos = UserDefaultsManager.shared.getMemoList() ?? []
        
        // 가져온 데이터에 새 메모 추가하기
        fetchedMemos.append(memo)
        
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMemoList(with: fetchedMemos)
        
        //print(#fileID, #function, #line, "kant test \(userInputVM?.$memoTextInput)")
    }
    
    fileprivate func deleteMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        
        // someResult = ["ㄴㅇㅇㅇ", "ㅇㄹㅇㄹ"]
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
    
    fileprivate func fetchMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경
        // someResult = ["ㄴㅇㅇㅇ", "ㅇㄹㅇㄹ"]
    }
    
}
