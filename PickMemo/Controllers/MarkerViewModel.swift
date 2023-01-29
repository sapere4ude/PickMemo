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
    @Published var marker: Marker = Marker(lat: nil, lng: nil, place: nil)
    
    // Output
    // 제일 중요한건 아래와 같이 Publisher 를 가공해주고, 이를 사용하는 곳에 데이터만 던져주는 방식이여야 한다는 것.
    lazy var createMarkerEventPublsher : AnyPublisher<(UInt, Double, Double), Never> = Publishers.CombineLatest($markerList, $marker)
        .map { markerList, marker -> (UInt, Double, Double) in
            let tag = UInt(markerList.count - 1)
            let lat = marker.lat ?? 0
            let lng = marker.lng ?? 0
            return (tag, lat, lng)
        }.eraseToAnyPublisher()
    
    enum Action {
        case create(_ marker: Marker)
        case search
        case fetch
    }
    
    var subscriptions = Set<AnyCancellable>()
    var inputAction = PassthroughSubject<Action, Never>()
    var addAction = PassthroughSubject<Void, Never>()

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
}
