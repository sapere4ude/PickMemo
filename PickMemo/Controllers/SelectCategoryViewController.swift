//
//  SelectCategoryViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/14.
//

import UIKit
import SnapKit

class SelectCategoryViewController: UIViewController {
    
    private lazy var selectCategoryView = SelectCategoryView()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubViews()
        configureUI()
        configureTapGesutre()
        onWillPresentView()
    }
    
    func configureSubViews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        dimmedView.addSubview(selectCategoryView)
        //view.addSubview(selectCategoryView)
    }
    
    func configureUI() {
        dimmedView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        selectCategoryView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(view.bounds.height)
        }
    }
    
    func configureTapGesutre() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onWillDismiss))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    // 커스텀 UI show 구현
    func onWillPresentView() {
        selectCategoryView.snp.remakeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
            $0.height.equalTo(self.view.bounds.height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onWillDismiss() {
        selectCategoryView.snp.remakeConstraints {
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
