//
//  ClickMarkerView.swift
//  PickMemo
//
//  Created by kant on 2023/01/02.
//

import UIKit

class ClickMarkerView: UIView {
    
    weak var delegate: ClickMarkerAction?
    var memo: Memo?
    var index: Int = -1
    
    private let baseView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    // 장소명
    private let placeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    // 카테고리
    private let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    // 메모내용
    private let memoLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "칸트")
        self.configureSubViews()
        self.configureUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(test))
        baseView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line, "칸트")
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
    }
    
    func configureSubViews() {
        self.addSubview(baseView)
        baseView.addSubview(contentsView)
        contentsView.addSubview(placeLabel)
        contentsView.addSubview(categoryLabel)
        contentsView.addSubview(memoLabel)
    }
    
    func configureUI() {
        baseView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(271)
        }
        
        placeLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(placeLabel.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        memoLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    func configureBinding(memo: Memo){
        print(#fileID, #function, #line, "칸트")
        placeLabel.text = memo.title
        categoryLabel.text = memo.category
        memoLabel.text = memo.memo
    }
    
    @objc func test() {
        delegate?.touchDimView()
    }
}
