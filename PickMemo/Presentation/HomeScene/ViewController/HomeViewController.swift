//
//  HomeViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/05/21.
//

import UIKit
import SnapKit
import RxSwift
import NMapsMap

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var memoViewModel: MemoViewModel? = nil
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    
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
    }
    
    func configureUI() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
    }
}
