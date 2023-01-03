//
//  ClickMarkerViewController.swift
//  PickMemo
//
//  Created by kant on 2023/01/02.
//

import UIKit
import CombineCocoa

class ClickMarkerViewController: UIViewController {
    
    private var clickMarkerView = ClickMarkerView()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureUI()
        onWillPresentView()
        
        dimmedView.coco
    }
    
    func configureSubViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(dimmedView)
        dimmedView.addSubview(clickMarkerView)
    }
    
    func configureUI() {
        dimmedView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    // 커스텀 UI show 구현
    func onWillPresentView() {
        clickMarkerView.snp.remakeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
            $0.height.equalTo(self.view.bounds.height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onWillDismiss() {
        clickMarkerView.snp.remakeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 2)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
}
