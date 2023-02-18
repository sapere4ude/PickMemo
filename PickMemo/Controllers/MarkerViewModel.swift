//
//  MarkerViewModel.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation
import Combine
import NMapsMap

extension Notification.Name {
    static let MemoDeletedEvent = Notification.Name(rawValue: "MEMO_LOCATION")
}

class MarkerViewModel {
    
    @Published var markerList:[Marker] = [Marker]()
    @Published var marker: Marker = Marker(lat: nil, lng: nil, place: nil)
    
    // Output
    // 제일 중요한건 아래와 같이 Publisher 를 가공해주고, 이를 사용하는 곳에 데이터만 던져주는 방식이여야 한다는 것.
    lazy var createMarkerEventPublsher : AnyPublisher<(UInt, Double, Double), Never> = Publishers.CombineLatest($markerList, $marker)
        .map { markerList, marker -> (UInt, Double, Double) in
            if markerList.count > 0 {
                let tag = UInt(markerList.count - 1)
                let lat = marker.lat ?? 0
                let lng = marker.lng ?? 0
                return (tag, lat, lng)
            } else {
                let tag = UInt(0)
                let lat = -1.0
                let lng = -1.0
                return (tag, lat, lng)
            }
        }.eraseToAnyPublisher()
    
    enum Action {
        case create(_ marker: Marker)
        case search
        case fetch
//        case remove(_ index: Int)
        case remove(_ id: UUID)
    }
    
    var subscriptions = Set<AnyCancellable>()
    var inputAction = PassthroughSubject<Action, Never>()
    var deleteAction = PassthroughSubject<(Double,Double), Never>()

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
                case .remove(let id):
                    self.removeMarker(id)
                }
            }.store(in: &subscriptions)
        
        NotificationCenter.default
            .publisher(for: .MemoDeletedEvent)
            .compactMap{ $0.userInfo }
            .compactMap{ $0["memoToBeDelete"] as? Memo }
            .compactMap{ ($0.lat, $0.lng) }
            .print("⭐️⭐️ noti MemoDeletedEvent")
            .sink { [weak self] location in
//                var tempMarkerList = UserDefaultsManager.shared.getMarkerList() ?? []
                #warning("TODO : - 지울 마커 알려주기 ")
//                if let nmfMarkerToBeDeleted = tempMarkerList.first(where: { $0.lat ?? 0 == location.0 && $0.lng ?? 0 == location.1 }) {
//
//                }
                self?.deleteAction.send(location)
//
//                if let nmfMarker = tempMarkerList.first(where: { $0.uuid == id }) {
//
//                    let markerLocation = (nmfMarker.lat ?? 0 , nmfMarker.lng ?? 0)
//
//                    deleteAction.send(markerLocation)
//                }
                
            }.store(in: &subscriptions)
    }
    
    fileprivate func createMarker(_ marker: Marker) {
        // 여기서 markerList 의 값이 두번 바뀌다보니깐 구독해둔 곳에서 2번 불리게 되는 문제가 있었음.
        // temp 에 임시로 값을 넣어줘서 markerList 의 값이 한번 바뀌는 방법으로 변경해서 해결해줌
        var tempMarkerList = UserDefaultsManager.shared.getMarkerList() ?? []
        tempMarkerList.append(marker)
        self.markerList = tempMarkerList
        // 업데이트 된 데이터 저장하기
        UserDefaultsManager.shared.setMarkerList(with: markerList)
    }
    
    func fetchMemo() -> [Marker] {
        markerList = UserDefaultsManager.shared.getMarkerList() ?? []
        print(#fileID, #function, #line, "kant test, fetchedMarkers:\(markerList)")
        return markerList
    }
    
    #warning("TODO : - 뷰모델 -> 뷰 - 마커지워라")
    //
    
    fileprivate func removeMarker(_ id: UUID) {
        
        var tempMarkerList = UserDefaultsManager.shared.getMarkerList() ?? []
        
        #warning("TODO : - 지울 마커 알려주기 ")
        
        self.markerList = tempMarkerList.filter{ $0.uuid != id }
        UserDefaultsManager.shared.setMarkerList(with: markerList)
        
        if let nmfMarker = tempMarkerList.first(where: { $0.uuid == id }) {
            
            let markerLocation = (nmfMarker.lat ?? 0 , nmfMarker.lng ?? 0)
            
            deleteAction.send(markerLocation)
        }
    }
    
    fileprivate func handleNoti(){
        print(#fileID, #function, #line, "- ")
    }
    
}

extension Optional {
    
    init<T, U>(_ optionalTuple: (T?, U?)) where Wrapped == (T, U) {
        
        switch optionalTuple {
        case (let t?, let u?):
            self = (t, u)
        default:
            self = nil
        }
    }
}
