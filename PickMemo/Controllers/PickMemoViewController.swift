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

class PickMemoViewController: UIViewController {
    
    private var tabBarHeight: CGFloat?
    
    var memoViewModel: MemoViewModel? = nil
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    var subscriptions = Set<AnyCancellable>()

    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        //mapView.layer.cornerRadius = 50
        mapView.clipsToBounds = true
        return mapView
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 장소를픽해주세요!"
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
    
    convenience init(memoViewModel: MemoViewModel){
        self.init()
        self.memoViewModel = memoViewModel
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
        
        naverMapProxy.$tapPosition.sink { tapPosition in
            print("tapPosition: \(tapPosition)")
            //self.createMarker(latlng: tapPosition)
        }.store(in: &subscriptions) // & <- inout
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
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    @objc func pressedButton() {
        // writePickMemoViewController
        //tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(WritePickMemoViewController(viewModel: memoViewModel, indexPath: nil), animated: true)

        // UI test
//        let test = SelectCategoryViewController()
//        test.modalPresentationStyle = .overFullScreen
//        self.present(test, animated: true)
    }
    
    // MARK: UI
    func configureSubViews() {
        view.backgroundColor = .systemBackground
        //title = "원하는 장소를 픽 해주세요!"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(mapView)
        //view.addSubview(mainTitleLabel)
        view.addSubview(sampleButton)
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
        
        sampleButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
