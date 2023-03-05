//
//  PickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit
import SnapKit
import NMapsMap
import Combine

protocol PickMemoAction: AnyObject {
    func createNewMemo(markerVM: MarkerViewModel, selectedMarker: Marker)
    
    func createMemo(markerVM: MarkerViewModel, selectedMarker: Marker?, selectedMemo: Memo?)
}

class PickMemoViewController: UIViewController, PickMemoAction {


    private var tabBarHeight: CGFloat?
    
    var memoViewModel: MemoViewModel? = nil
    var memo: [Memo]?
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    var subscriptions = Set<AnyCancellable>()
    var markerArray: [NMFMarker] = [NMFMarker]()
    
    let locationProxy = CLLocationProxy()
    
    var locationManager = CLLocationManager()
    
    private lazy var naverMapView = NMFNaverMapView(frame: view.frame)
    private var mapView: NMFMapView { naverMapView.mapView }
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 장소를 픽해주세요!"
        label.backgroundColor = .red
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 15
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(memoViewModel: MemoViewModel, markerViewModel: MarkerViewModel){
        self.init()
        self.memoViewModel = memoViewModel
        self.markerViewModel = markerViewModel
        self.naverMapProxy = NaverMapProxy(markerVM: markerViewModel, memoVM: memoViewModel)
        print(#fileID, #function, #line, "kant test")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarHeight = (self.tabBarController?.tabBar.frame.size.height)!
        configureSubViews()
        configureUI()
        
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        
        naverMapView.mapView.positionMode = .direction
        
        mapView.touchDelegate = naverMapProxy
        
        naverMapProxy.delegate = self
        
        naverMapProxy.$tapPosition.sink { tapPosition in
            //self.createMarker(lat: tapPosition?.lat, lng: tapPosition?.lng)
            //print(#fileID, #function, #line, "칸트")
        }.store(in: &subscriptions) // & <- inout
        
        memoViewModel?.inputAction.send(.fetch)
        markerViewModel?.inputAction.send(.fetch)
        
        // 앱 최초 실행시 한번만 타도 괜찮은 코드
//        configureMarker(markerViewModel: markerViewModel!)
        
        // TODO: - 마커리스트가 변경될때마다 불리는게 아니라 메모 생성 이후에 액션을 던졌을때 마커가 생성되는 방식으로 변경되어야함
        markerViewModel?
            .$markerList
            .receive(on: RunLoop.main)
            .print("⭐️⭐️ markerDTOList")
            .sink { updatedMarkerList in
                print(#fileID, #function, #line, "칸트")
                updatedMarkerList.forEach{
                    self.createAMarker(marker: $0)
                }
//                guard let markerVM = self.markerViewModel else { return } <- markerVM 이 재참고가 되는 방식이라 두번 불리게 될 가능성이 있음
//                self.createMarker(markerViewModel: markerVM)
            }.store(in: &subscriptions)
        
        memoViewModel?.$memoList
            .print()
            .receive(on: RunLoop.main)
            .sink {_ in
                //self.memoViewModel = self.memoViewModel
                print(#fileID, #function, #line, "칸트")
            }.store(in: &subscriptions)
        
        markerViewModel?
            .deleteAction
            .print("⭐️⭐️ markerDTOList deleteAction")
            .receive(on: RunLoop.main)
            .sink { location in
                // TODO: - remove marker index
                self.removeNmfMarker(lat: location.0, lng: location.1)
            }.store(in: &subscriptions)
        
        // 위치 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = locationProxy
        
        
        locationProxy
            .recentLocationAction // lat, lng
            .prefix(1)
            .print("⭐️ recentLocationAction")
            .receive(on: DispatchQueue.main)
            .map{ NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.0, lng: $0.1)) }
            .sink { [weak self] cameraUpdate in
                cameraUpdate.animation = .easeIn
                print(#fileID, #function, #line, "- cameraUpdate: \(cameraUpdate)")
                self?.mapView.moveCamera(cameraUpdate)
            }
            .store(in: &subscriptions)
        
        locationProxy
            .checkLocationAuthStatusAction
            .sink(receiveValue: { [weak self] in
                // 위치 상태 확인
                self?.checkLocationAuthStatus()
            })
            .store(in: &subscriptions)
        
        self.checkLocationAuthStatus()
    }
    
    // 위치 상태 확인
     func checkLocationAuthStatus() {
         // 위치정보 확인 상태가 항상 허용이라면
         let authorizationStatus = CLLocationManager.authorizationStatus()
         if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
             // 위치 갱신 시작
             locationManager.startUpdatingLocation()
             // TODO: - 위치 갱신 코드 호출
             let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
             cameraUpdate.animation = .easeIn
             naverMapView.mapView.moveCamera(cameraUpdate)
         } else {
             // 항상 허용이 아니면
             // 위치 정보 허용을 요청한다.
             setAuthAlertAction()
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#fileID, #function, #line, "칸트")
    }
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackThree
        view.alpha = 0.6
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // MARK: UI
    func configureSubViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(naverMapView)
    }

    func configureUI() {
        naverMapView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    // 단일 nmfMarker 설정
    func createAMarker(marker: Marker) {
        print(#fileID, #function, #line, "marker: \(marker)")
        
        let currentNMFMarker = marker.getNMFMarker()
        //currentNMFMarker.iconImage = NMF_MARKER_IMAGE_BLACK
        let test = "❤️".emojiToImage()!
        currentNMFMarker.iconImage = NMFOverlayImage(image: test)
        //currentNMFMarker.iconTintColor = .green1

        currentNMFMarker.iconTintColor = .clear
//        currentNMFMarker.width =  50
//        currentNMFMarker.height = 50
        
        currentNMFMarker.mapView = mapView
        
        // 마커 클릭시 화면 띄우기
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
        print(#fileID, #function, #line, "- lat:\(lat), lng: \(lng)")
        if let foundMarker = self.markerArray.first(where: {
            $0.position.lat == lat && $0.position.lng == lng
        }) {
            foundMarker.mapView = nil
        }
    }
    
    func removeAMarker(nmfMarker: NMFMarker?) {
        // TODO: - 여기서 마커를 어떻게 없앨 수 있을까..?
        print(#fileID, #function, #line, "칸트")
        if let anNmfMarker = nmfMarker{
            anNmfMarker.mapView = nil
        }
    }
    
    func removeMarker(index: Int) {
        // TODO: - 여기서 마커를 어떻게 없앨 수 있을까..?
        print(#fileID, #function, #line, "칸트")
        let marker: NMFMarker = markerArray[index]
        
        marker.mapView = nil
    }
    
    func createMemo(markerVM: MarkerViewModel, selectedMarker: Marker?, selectedMemo: Memo?) {
        
        let writePickMemoVC = WritePickMemoViewController(markerVM: markerVM,
                                                          selectedMarker: selectedMarker,
                                                          selectedMemo: selectedMemo)
        
        self.navigationController?.pushViewController(writePickMemoVC, animated: true)
    }
    
    func createNewMemo(markerVM: MarkerViewModel, selectedMarker: Marker) {
        let writePickMemoVC = WritePickMemoViewController(markerVM: markerVM,
                                                          selectedMarker: selectedMarker)
        
        self.navigationController?.pushViewController(writePickMemoVC, animated: true)
    }
    
    func setAuthAlertAction() {
            let authAlertController : UIAlertController
            
            authAlertController = UIAlertController(title: "위치 사용 권한을 허용해주세요.", message: "위치 사용시 앱 사용을 더욱 효율적으로 사용할 수 있습니다!", preferredStyle: .alert)
            
            let getAuthAction : UIAlertAction
            getAuthAction = UIAlertAction(title: "설정으로 이동하기", style: .default, handler: { (UIAlertAction) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
                }
            })
            authAlertController.addAction(getAuthAction)
            self.present(authAlertController, animated: true, completion: nil)
        }
}
