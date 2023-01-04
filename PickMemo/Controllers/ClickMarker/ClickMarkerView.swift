//
//  ClickMarkerView.swift
//  PickMemo
//
//  Created by kant on 2023/01/02.
//

import UIKit

class ClickMarkerView: UIView {
    
    weak var delegate: ClickMarkerAction?
    var memoVM: MemoViewModel?
    
    private let baseView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
//        view.backgroundColor = .systemBackground
        view.backgroundColor = .blue
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(memoVM: MemoViewModel) {
        self.init(frame: .zero)
        self.memoVM = memoVM
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
    }
    
    func configureSubViews() {
        self.addSubview(baseView)
        baseView.addSubview(contentsView)
    }
    
    func configureUI() {
        baseView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(271)
        }
    }
    
    func configureBinding(){
        print(#fileID, #function, #line, "- ")
//        selectCategoryViewModel?
//            .$selectCategory // SelectCategory?
//            .compactMap{ $0 } // SelectCategory
//            .map{ $0.category } // String
//            .assign(to: \.text, on: titleLabel)
//            .store(in: &subscriptions)
    }

    func configureTapGesutre(target: Any?, action: Selector) {
//        let tapGesture = UITapGestureRecognizer(target: target, action: action)
//        baseView.addGestureRecognizer(tapGesture)
        delegate?.touchDimView()
    }
}
