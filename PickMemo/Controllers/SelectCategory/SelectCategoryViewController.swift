//
//  SelectCategoryViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/14.
//

import UIKit
import SnapKit
import Combine

class SelectCategoryViewController: UIViewController {
    
    private lazy var selectCategoryView = SelectCategoryView()
    
    var selectCategoryVM : SelectCategoryViewModel? = nil
    
    var subscriptions = Set<AnyCancellable>()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    init(vm: SelectCategoryViewModel) {
        self.selectCategoryVM = vm
        super.init(nibName: nil, bundle: nil)
        print(#fileID, #function, #line, "- self.selectCategoryVM: \(self.selectCategoryVM)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCategoryView.selectCategoryViewModel = selectCategoryVM
        
        configureSubViews()
        configureUI()
        configureTapGesutre()
        onWillPresentView()
        
        selectCategoryView.configureTapGesutre(target: self, action: #selector(onWillDismiss))
        
        selectCategoryVM?
            .dismissAction
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print(#fileID, #function, #line, "- ")
                self.onWillDismiss()
            }
            .store(in: &subscriptions)
        
    }
    
    func configureSubViews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        dimmedView.addSubview(selectCategoryView)
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
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onWillDismiss))
//        dimmedView.addGestureRecognizer(tapGesture)
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
