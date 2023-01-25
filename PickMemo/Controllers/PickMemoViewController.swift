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
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
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
            //self.createMarker(lat: tapPosition?.lat, lng: tapPosition?.lng)
            //print(#fileID, #function, #line, "칸트")
        }.store(in: &subscriptions) // & <- inout
        
        memoViewModel?.inputAction.send(.fetch)
        markerViewModel?.inputAction.send(.fetch)
        
        // 앱 최초 실행시 한번만 타도 괜찮은 코드
        configureMarker(markerViewModel: markerViewModel!)
        
        // TODO: - 마커리스트가 변경될때마다 불리는게 아니라 메모 생성 이후에 액션을 던졌을때 마커가 생성되는 방식으로 변경되어야함
        markerViewModel?.$markerList
            .receive(on: RunLoop.main)
            .sink { _ in
                print(#fileID, #function, #line, "칸트 dys")
                guard let markerVM = self.markerViewModel else { return }
                self.createMarker(markerViewModel: markerVM)
            }.store(in: &subscriptions)

        memoViewModel?.$memoList
            .print()
            .receive(on: RunLoop.main)
            .sink {_ in
                self.memoViewModel = self.memoViewModel
                print(#fileID, #function, #line, "칸트")
            }.store(in: &subscriptions)
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
        view.addSubview(mapView)
    }

    func configureUI() {
        mapView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: - 첫 진입시 갖고 있는 마커들을 표시해주는 메서드
    func configureMarker(markerViewModel: MarkerViewModel) {
        guard markerViewModel != nil else { return }
        for (index, savedMarker) in markerViewModel.markerList.enumerated() {
            print(#fileID, #function, #line, "칸트 index: \(index)")
            guard let lat = savedMarker.lat, let lng = savedMarker.lng else { return }
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.tag = UInt(index)
            marker.mapView = mapView
            
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let memoVM = self?.memoViewModel {
                    let test = ClickMarkerViewController(memoVM: memoVM, index: index)
                    test.modalPresentationStyle = .overFullScreen
                    self?.present(test, animated: true)
                }
                return true
            };
            marker.touchHandler = handler
        }
    }
    
    // MARK: - 앱 사용중 메모 생성으로 만들어지는 마커를 표시해주기 위한 메서드
    func createMarker(markerViewModel: MarkerViewModel) {
        print(#fileID, #function, #line, "칸트")
        guard let lat = markerViewModel.marker.lat, let lng = markerViewModel.marker.lng else { return }
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.tag = UInt(markerViewModel.markerList.count - 1)
        print(#fileID, #function, #line, "칸트, maker.tag:\(marker.tag)")
        marker.mapView = mapView
        
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            if let memoVM = self?.memoViewModel {
                memoVM.inputAction.send(.fetch)
                let test = ClickMarkerViewController(memoVM: memoVM, index: Int(marker.tag))
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
