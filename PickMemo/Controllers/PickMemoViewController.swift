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
    func createMemo(markerVM: MarkerViewModel)
}

class PickMemoViewController: UIViewController, PickMemoAction {

    private var tabBarHeight: CGFloat?
    
    var memoViewModel: MemoViewModel? = nil
    var memo: [Memo]?
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    var subscriptions = Set<AnyCancellable>()
    var testtest: Int = -1

    let marker = NMFMarker()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        //mapView.layer.cornerRadius = 50
        mapView.clipsToBounds = true
        return mapView
    }()
    
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
        mapView.touchDelegate = naverMapProxy
        
        naverMapProxy.delegate = self
        
        naverMapProxy.$tapPosition.sink { tapPosition in
            self.createMarker(lat: tapPosition?.lat, lng: tapPosition?.lng)
        }.store(in: &subscriptions) // & <- inout
        
        markerViewModel?.$markerList
            .print()
            .receive(on: RunLoop.main)
            .sink {
                if let test = $0.last {
//                    self.createMarker(lat: test.lat, lng: test.lng)
                }
            }.store(in: &subscriptions)
        
//        naverMapProxy.$myMarkerIndex
//            .receive(on: RunLoop.main)
//            .dropFirst(1)
//            .sink { myMarkerIndex in
                //let test = ClickMarkerViewController()
//                if let memoVM = self.memoViewModel {
//                    let test = ClickMarkerViewController(memoVM: memoVM, index: self.naverMapProxy.myMarkerIndex)
//                    //let test = ClickMarkerViewController(memo: memoVM.memoList[self.naverMapProxy.myMarkerIndex])
//                    test.modalPresentationStyle = .overFullScreen
//                    self.present(test, animated: true)
//                }
//                self.testtest = myMarkerIndex
//            }.store(in: &subscriptions)
        
        memoViewModel?.$memoList
            .print()
            .receive(on: RunLoop.main)
            .sink {_ in
                self.memoViewModel = self.memoViewModel
                print(#fileID, #function, #line, "칸트")
            }
        
        memoViewModel?.$myMarkerIndex
            .print()
            .receive(on: RunLoop.main)
            .sink {
                self.testtest = $0
                print(#fileID, #function, #line, "칸트")
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoViewModel?.inputAction.send(.fetch)
        markerViewModel?.inputAction.send(.fetch)
    }
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackThree
        view.alpha = 0.6
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var sampleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        //button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
//    @objc func pressedButton() {
//        // writePickMemoViewController
//        //tabBarController?.tabBar.isHidden = true
//        self.navigationController?.pushViewController(WritePickMemoViewController(viewModel: memoViewModel, indexPath: nil), animated: true)
//
//        // UI test
////        let test = SelectCategoryViewController()
////        test.modalPresentationStyle = .overFullScreen
////        self.present(test, animated: true)
//    }
    
    // MARK: UI
    func configureSubViews() {
        view.backgroundColor = .systemBackground
        //title = "원하는 장소를 픽 해주세요!"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(mapView)
        //view.addSubview(mainTitleLabel)
        //view.addSubview(sampleButton)
    }

    func configureUI() {
//        mapView.snp.makeConstraints {
//            $0.centerX.centerY.equalToSuperview()
//            $0.width.equalToSuperview()
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
//            $0.bottom.equalToSuperview().offset(-tabBarHeight!)
//        }
        
        mapView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
//        sampleButton.snp.makeConstraints {
//            $0.width.equalTo(50)
//            $0.height.equalTo(50)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalToSuperview()
//        }
    }
    
    // 입력 받은 위치에 대한 마커 생성
    func createMarker(lat: Double?, lng: Double?) {
        guard let lat = lat, let lng = lng else { return }
        //let marker = NMFMarker()
        
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = mapView
        
        // TODO: - 입력받은 값을 뷰모델에 저장해주기
           
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
//            if let marker = overlay as? NMFMarker {
//                if marker.infoWindow == nil {
//                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
//                    //                    self?.infoWindow.open(with: marker)
//                    if let memoVM = self.memoViewModel {
//                        let test = ClickMarkerViewController(memoVM: memoVM, index: self.naverMapProxy.myMarkerIndex)
//                        test.modalPresentationStyle = .overFullScreen
//                        self.present(test, animated: true)
//                    }
//                } else {
//                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
//                    //                    self?.infoWindow.close()
//                }
//            }
            
            if let memoVM = self?.memoViewModel {
                print(#fileID, #function, #line, "칸트")
                let test = ClickMarkerViewController(memoVM: memoVM, index: self?.testtest ?? -1)
                test.modalPresentationStyle = .overFullScreen
                self?.present(test, animated: true)
            }
            
            return true
        };
        marker.touchHandler = handler
    }
    
    func createMemo(markerVM: MarkerViewModel) {
        self.navigationController?.pushViewController(WritePickMemoViewController(markerVM: markerVM), animated: true)
    }
}
