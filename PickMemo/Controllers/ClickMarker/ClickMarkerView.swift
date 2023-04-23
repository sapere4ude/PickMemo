//
//  ClickMarkerView.swift
//  PickMemo
//
//  Created by kant on 2023/01/02.
//

import UIKit

class ClickMarkerView: UIView {
    
    weak var delegate: ClickMarkerAction?
    var memo: Memo? {
        didSet{
            if let memo = memo {
                DispatchQueue.main.async {
                    self.configureBinding(memo: memo)
                }
            }
        }
    }
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

    private let placeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 17)
        return textView
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
        contentsView.addSubview(memoTextView)
    }
    
    func configureUI() {
        baseView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(271)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.top.equalTo(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        placeLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        memoTextView.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.right.equalTo(-12)
            $0.top.equalTo(placeLabel.snp.bottom).offset(15)
            $0.bottom.equalTo(-10)
        }
    }
    
    func configureBinding(memo: Memo){
        print(#fileID, #function, #line, "칸트")
        placeLabel.text = memo.title
        categoryLabel.text = memo.category
        memoTextView.text = memo.memo
    }
    
    @objc func test() {
        delegate?.touchDimView()
    }
}
