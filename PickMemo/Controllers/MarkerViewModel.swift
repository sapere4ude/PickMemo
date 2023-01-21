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
    //@Published var marker = Marker(userInfo: ["": ""])
    @Published var marker = Marker(lat: 0.0, lng: 0.0, place: nil)
    
    enum Action {
        case create(_ marker: Marker)
        case search
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    var inputAction = PassthroughSubject<Action, Never>()
    
//    init(markerList: [Marker]) {
//        self.markerList = markerList
//
//        inputAction
//            .sink { [weak self] action in
//                guard let self = self else { return }
//                switch action {
//                case .create(let marker):
//                    self.createMarker(marker)
//                case .search:
//                    print("test")
//                case .fetch:
//                    print("fetch")
//                }
//            }.store(in: &subscriptions)
//    }
    
    init() {
        inputAction
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .create(let marker):
                    self.createMarker(marker)
                case .search:
                    print("test")
                case .fetch:
                    self.fetchMemo()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMarker(_ marker: Marker) {
        markerList = UserDefaultsManager.shared.getMarkerList() ?? []
        markerList.append(marker)
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMarkerList(with: markerList)
    }
    
    func fetchMemo() -> [Marker] {
        markerList = UserDefaultsManager.shared.getMarkerList() ?? []
        print(#fileID, #function, #line, "kant test, fetchedMarkers:\(markerList)")
        return markerList
    }
}
