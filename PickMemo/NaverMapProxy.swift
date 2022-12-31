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
}

// TODO: 마커를 생성 하는 메서드 만들기, 마커 UI 생성하는 것만 VC 에서 작성해주기

class NaverMapProxy: NSObject, ObservableObject, NMFMapViewTouchDelegate {

    @Published var tapPosition: NMGLatLng? = nil
    @Published var symbol: NMFSymbol? = nil
    var outputAction = PassthroughSubject<UpdateMapAction, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    var isCreateMarker: Bool = true
    var isRegisterCaption: Bool = true
    //var pickMemosVM = PickMemosVM()
    
    var markerVM = MarkerViewModel(markerList: <#[Marker]#>)

    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        if(symbol.caption.count > 0) {
//            pickMemosVM.pickMemos.forEach { pickMemo in
//                if pickMemo.symbol?.caption == symbol.caption && pickMemo.latlng == symbol.position {
//                    // TODO: 터치 이벤트가 존재하지 않으면 생성할 수 있도록 조건 추가하기 & pickMemo 안에서 마커도 관리할 수 있도록 수정
//                    self.symbol = symbol
//                    isCreateMarker = false
//                }
//            }
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

        tapPosition = latlng // 이 값을 전달해주면 VC에서 create Marker 진행됨
        //pickMemosVM.addMemo(text: "test", latlng: latlng, symbol: self.symbol)
        //outputAction.send(.createMarker(tapPosition!))
    }
}
