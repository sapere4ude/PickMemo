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
        case create(_ userInputVM: UserInputViewModel, _ selectedMarker: Marker)
        case delete(_ memoId: UUID)
        case reset
        case modify(_ userInputVM: UserInputViewModel, _ selectedMemo: Memo)
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
                case .delete(let memoId):
                    self.deleteMemo(memoId)
                case .reset:
                    self.resetMemo()
                case .modify(let userInputVM, let selectedMemo):
                    self.modifyMemo(userInputVM, selectedMemo)
                case .fetch:
                    self.fetchMemo()
                }
            }.store(in: &subscriptions)
        fetchMemo()
    }
    
    fileprivate func createMemo(_ userInputVM: UserInputViewModel, _ selectedMarker: Marker) {
        
        guard let lat = selectedMarker.lat,
                let lng = selectedMarker.lng else { return }
                
        
        let memo = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput, lat: lat, lng: lng)
        
        var tempMemoList = UserDefaultsManager.shared.getMemoList() ?? []
        tempMemoList.append(memo)
        self.memoList = tempMemoList
        
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMemoList(with: memoList)
    }

    fileprivate func deleteMemo(_ memoId: UUID) {
        // TODO: - 메모 삭제했을때 마커 다시 그려주는 로직 태워야함
        var tempMemoList = UserDefaultsManager.shared.getMemoList() ?? []
        
        let memoToBeDelete = tempMemoList.first(where: {
            $0.uuid == memoId
        })
        
        NotificationCenter.default.post(name: .MemoDeletedEvent, object: nil, userInfo: ["memoToBeDelete": memoToBeDelete])
        
        tempMemoList = tempMemoList.filter({
            $0.uuid != memoId
        })

        self.memoList = tempMemoList
        UserDefaultsManager.shared.setMemoList(with: memoList)
        
    }
    
    fileprivate func resetMemo(){
        // 뭔가 로직처리후
        // 완성 상태 변경 (코드테스트)
    }
    
    fileprivate func modifyMemo(_ userInputVM: UserInputViewModel,
                                _ selectedMemo: Memo) {
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        
        if let editIndex = memoList.firstIndex(where: {
            $0.lat == selectedMemo.lat && $0.lng == selectedMemo.lng }) {
            
            memoList[editIndex] = Memo(title: userInputVM.titleTextInput, memo: userInputVM.memoTextInput, category: userInputVM.categoryInput, lat: selectedMemo.lat, lng: selectedMemo.lng)
            
            UserDefaultsManager.shared.setMemoList(with: memoList)
        }
    }
    
    fileprivate func fetchMemo() -> [Memo] {
        memoList = UserDefaultsManager.shared.getMemoList() ?? []
        print(#fileID, #function, #line, "kant test, fetchedMemos:\(memoList)")
        return memoList
    }
}
