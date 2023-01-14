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
        view.backgroundColor = .systemYellow
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
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(test))
        baseView.addGestureRecognizer(tapGesture)

    }
    
    convenience init(memo: Memo) {
        print(#fileID, #function, #line, "kant test")
        self.init(frame: .zero)
        self.memo = memo
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line, "kant test")
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
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
        
        categoryLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(placeLabel.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    func configureBinding(){
        print(#fileID, #function, #line, "kant test")
        placeLabel.text = memo?.title
    }
    
    @objc func test() {
        delegate?.touchDimView()
    }
}
