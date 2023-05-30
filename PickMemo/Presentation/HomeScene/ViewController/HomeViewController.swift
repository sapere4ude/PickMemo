//
//  HomeViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/05/21.
//

import UIKit
import SnapKit
import Combine
import NMapsMap

final class HomeViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    var markerArray: [NMFMarker] = [NMFMarker]()
    
    var memoViewModel: MemoViewModel? = nil
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    
    var locationManager = CLLocationManager()
    
    private lazy var naverMapView = NMFNaverMapView(frame: view.frame)
    private var mapView: NMFMapView { naverMapView.mapView }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(memoViewModel: MemoViewModel, markerViewModel: MarkerViewModel){
        self.init()
        self.memoViewModel = memoViewModel
        self.markerViewModel = markerViewModel
        self.naverMapProxy = NaverMapProxy(markerVM: markerViewModel, memoVM: memoViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        configureNaverMapUI()
        mapView.touchDelegate = naverMapProxy
        setupBindings()
    }
    
    func configureUI() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.showToast("지도에서 원하는 장소를 클릭해주세요!", delay: 4.0)
        view.backgroundColor = .systemBackground
        view.addSubview(naverMapView)
        naverMapView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func configureNaverMapUI() {
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        naverMapView.mapView.positionMode = .direction
    }
    
    func setupBindings() {
        naverMapProxy.delegate = self
        naverMapProxy.$tapPosition.sink { tapPosition in }.store(in: &subscriptions)
        memoViewModel?.inputAction.send(.fetch)
        markerViewModel?.inputAction.send(.fetch)
        
        markerViewModel?
            .$markerList
            .receive(on: RunLoop.main)
            .sink { updatedMarkerList in
                for (index, marker) in updatedMarkerList.enumerated() {
                    self.createAMarker(marker: marker, index: index)
                }
            }
            .store(in: &subscriptions)
        
        markerViewModel?
            .createFinishAction
            .receive(on: RunLoop.main)
            .sink { updatedMarkerList in
                for (index, marker) in updatedMarkerList.enumerated() {
                    self.createAMarker(marker: marker, index: index)
                }
            }
            .store(in: &subscriptions)
        
        markerViewModel?
            .deleteAction
            .receive(on: RunLoop.main)
            .sink { location in
                self.removeNmfMarker(lat: location.0, lng: location.1)
            }.store(in: &subscriptions)
    }
    
    // TODO: - 요런것들도 ViewModel에 싹다 넣어주는 방식으로 변경이 필요함
    
    // 단일 nmfMarker 설정
    func createAMarker(marker: Marker, index: Int) {
        self.memoViewModel?.inputAction.send(.fetch)
        
        guard markerViewModel?.markerList.count != 0, memoViewModel?.memoList.count != 0 else { return }
        
        let currentNMFMarker = marker.getNMFMarker()
        let emojiCharacter:Character = (memoViewModel?.memoList[index].category?.first)!
        let emoji: String = String(emojiCharacter)

        let test = emoji.emojiToImage()!
        
        currentNMFMarker.iconImage = NMFOverlayImage(image: test)
        currentNMFMarker.iconTintColor = .clear
        
        currentNMFMarker.mapView = mapView
        
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            if let memoVM = self?.memoViewModel {

                memoVM.inputAction.send(.fetch)
                let test = ClickMarkerViewController(memoVM: memoVM, selectedMarker: marker)
                
                test.modalPresentationStyle = .overFullScreen
                self?.present(test, animated: true)
            }
            return true
        };
        currentNMFMarker.touchHandler = handler
        
        // 나중에 지우기 위해 넣기
        markerArray.append(currentNMFMarker)
    }
    
    func removeNmfMarker(lat: Double, lng: Double) {
        if let foundMarker = self.markerArray.first(where: {
            $0.position.lat == lat && $0.position.lng == lng
        }) {
            foundMarker.mapView = nil
        }
    }
}

extension HomeViewController: PickMemoAction {
    func createNewMemo(markerVM: MarkerViewModel, selectedMarker: Marker) {
        let writePickMemoVC = WritePickMemoViewController(markerVM: markerVM,
                                                          selectedMarker: selectedMarker)
        
        // TODO: - Coordinator pattern 적용필요
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(writePickMemoVC, animated: true)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    func createMemo(markerVM: MarkerViewModel, selectedMarker: Marker?, selectedMemo: Memo?) {
        let writePickMemoVC = WritePickMemoViewController(markerVM: markerVM,
                                                          selectedMarker: selectedMarker,
                                                          selectedMemo: selectedMemo)
        
        self.navigationController?.pushViewController(writePickMemoVC, animated: true)
    }
}
