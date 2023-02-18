//
//  ClickMarkerViewController.swift
//  PickMemo
//
//  Created by kant on 2023/01/02.
//

import UIKit
import Combine
import CombineCocoa

protocol ClickMarkerAction: AnyObject {
    func touchDimView()
}

class ClickMarkerViewController: UIViewController {
    
    lazy var clickMarkerView = ClickMarkerView()
    var memoVM: MemoViewModel?
    var memo: Memo? {
        didSet{
            print(#fileID, #function, #line, "- memo: \(memo)")
            if let currentMemo = self.memo {
                DispatchQueue.main.async {
                    self.clickMarkerView.configureBinding(memo: currentMemo)
                }
            }
        }
    }
    var index: Int = -1
    
    @Published var currentMarker : Marker? = nil
    lazy var marker : AnyPublisher<Marker, Never> = $currentMarker.compactMap{ $0 }.eraseToAnyPublisher()
    
    init(memoVM: MemoViewModel, selectedMarker: Marker) {
        super.init(nibName: nil, bundle: nil)
        print(#fileID, #function, #line, "selectedMarker: \(selectedMarker)")
        self.memoVM = memoVM
        self.currentMarker = selectedMarker
        
        var cancellable : AnyCancellable? = Publishers.CombineLatest(memoVM.$memoList, marker)
            .compactMap({ memoList, currentMarker -> Memo? in
                return memoList.filter{ $0.lat == currentMarker.lat && $0.lng == currentMarker.lng }.first
            })
            .eraseToAnyPublisher()
            .print("⭐️ currentMemo")
            .assign(to: \.memo, on: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureUI()
        onWillPresentView()

        
        
//        clickMarkerView.configureBinding(memo: (self.memoVM?.memoList[self.index])!)
        clickMarkerView.delegate = self // 이게 있어야 액션을 전달받을 수 있음
    }
    
    func configureSubViews() {
        view.backgroundColor = .clear
        view.addSubview(clickMarkerView)
    }
    
    func configureUI() {
        clickMarkerView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    // 커스텀 UI show 구현
    func onWillPresentView() {
        clickMarkerView.snp.remakeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
            $0.height.equalTo(self.view.bounds.height)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onWillDismiss() {
        clickMarkerView.snp.remakeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 2)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
}

extension ClickMarkerViewController: ClickMarkerAction {
    func touchDimView() {
        self.onWillDismiss()
    }
}

