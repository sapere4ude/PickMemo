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
    var placeLatlng: String?
    var lat: Double?
    var lng: Double?
    
    weak var delegate: PickMemoAction?

    convenience init(markerVM: MarkerViewModel, memoVM: MemoViewModel) {
        self.init()
        self.markerVM = markerVM
        self.memoVM = memoVM
    }
    
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {

        guard let markerList = markerVM?.markerList else { return true }

        let circle = NMFCircleOverlay()
        circle.center = symbol.position

        for (index, marker) in markerList.enumerated() {
            if symbol.caption == marker.place &&
                symbol.position.toLatLng().lat == marker.lat &&
                symbol.position.toLatLng().lng == marker.lng {
                print("중복값 존재")
                break
            }
        }

        print(#fileID, #function, #line, "toLatLng:\(symbol.position.toLatLng())")

        if(symbol.caption.count > 0) {
            self.place = symbol.caption
            self.lat = symbol.position.toLatLng().lat
            self.lng = symbol.position.toLatLng().lng
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
        guard let markerVM = markerVM , let marker = markerVM.marker else { return }
        marker.lat = self.lat
        marker.lng = self.lng
        marker.place = place!
        //myMarkerIndex = markerVM.markerList.count - 1
        
        
        // 마커 값들을 리스트에 저장해주는 과정 필요
//        markerVM.inputAction.send(.create(markerVM.marker))
        delegate?.createMemo(markerVM: markerVM)
    }
}
