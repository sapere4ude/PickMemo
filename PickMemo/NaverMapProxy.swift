//
//  NaverMapProxy.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation
import Combine
import NMapsMap

enum UpdateMapAction {
    case createMarker(_ lat: NMGLatLng)
    case moveCamera
    case showMarkerVC(_ index: Int)
    case createMemo
}

// TODO: 마커를 생성 하는 메서드 만들기, 마커 UI 생성하는 것만 VC 에서 작성해주기

class NaverMapProxy: NSObject, ObservableObject, NMFMapViewTouchDelegate {

    @Published var markerInfo: Marker? = nil
    @Published var tapPosition: NMGLatLng? = nil
    @Published var symbol: NMFSymbol? = nil
    @Published var myMarkerIndex: Int = -1
    var outputAction = PassthroughSubject<UpdateMapAction, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    var isCreateMarker: Bool = true
    var isRegisterCaption: Bool = true
    var markerVM: MarkerViewModel?
    var memoVM: MemoViewModel?
    var place: String?
    
    weak var delegate: PickMemoAction?

    convenience init(markerVM: MarkerViewModel, memoVM: MemoViewModel) {
        self.init()
        self.markerVM = markerVM
        self.memoVM = memoVM
    }
    
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {

        guard let markerList = markerVM?.markerList else { return true }

//        for (index, marker) in markerList.enumerated() {
//            // 여기 걸리면 기존에 저장해둔 마커가 있다는 소리니깐 내용을 보여주면 됨
//            // 마커 인덱스를 가져와서 메모VM의 몇번째 리스트인지를 가져오기
//            //if trunc(marker.lng ?? 0) == trunc(symbol.position.lng) && trunc(marker.lat ?? 0) == trunc(symbol.position.lat) {
//            if marker.lng ?? 0 == symbol.position.lng && marker.lat ?? 0 == symbol.position.lat {
//                if let memoVM = memoVM {
//                    //let memo:Memo = memoVM.memoList[index]
//                    //outputAction.send(.showMarkerVC(index))
//                    myMarkerIndex = index
//                }
//
//                // 새로운 뷰 보여줄 수 있는 ㄹ
//                return true
//            }
//        }

        if(symbol.caption.count > 0) {
            self.place = symbol.caption
            isRegisterCaption = false
            return false // 마커 만들 수 있다
        } else {
            return true // 마커 만들 수 없다
        }
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        guard isCreateMarker == true else { return }
        guard isRegisterCaption == false else { return }
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        isRegisterCaption = true

        // 이 값을 전달해주면 VC에서 create Marker 진행됨. (마커 그리기 완성)
        tapPosition = latlng
        guard let markerVM = markerVM else { return }
        markerVM.marker.userInfo = ["latlng": "\(latlng)", "place": place!]
        
        // 마커 값들을 리스트에 저장해주는 과정 필요
        markerVM.inputAction.send(.create(markerVM.marker))
        delegate?.createMemo(markerVM: markerVM) // 이 부분은 메모 등록시에 탈 수 있도록 수정해줘야할 것 같음
    }
}
