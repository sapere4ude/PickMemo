//
//  WritePickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import Foundation
import UIKit
import SnapKit

class WritePickMemoViewController: UIViewController {
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.backgroundColor = .white
        titleTextField.layer.cornerRadius = 15
        titleTextField.addLeftPadding()
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return titleTextField
    }()
    
    private let categoryTextField: UITextField = {
        let categoryTextField = UITextField()
        categoryTextField.backgroundColor = .white
        categoryTextField.layer.cornerRadius = 15
        categoryTextField.addLeftPadding()
        categoryTextField.attributedPlaceholder = NSAttributedString(string: "카테고리를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        categoryTextField.isUserInteractionEnabled = false
        categoryTextField.addLeftPadding()
        return categoryTextField
    }()
    
    private lazy var touchCategotyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(touchCategory), for: .touchUpInside)
        return button
    }()
    
    private lazy var memoTextView: UITextView = {
        let memoTextView = UITextView()
        memoTextView.layer.cornerRadius = 15
        memoTextView.clipsToBounds = true
        memoTextView.backgroundColor = .white
        memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        memoTextView.text = "원하는 글을 작성해주세요."
        memoTextView.textColor = .systemGray
        memoTextView.font = .systemFont(ofSize: 18)
        memoTextView.delegate = self
        return memoTextView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("등록하기", for: .normal)
        button.backgroundColor = .systemGray4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "저장하기"
        
        configureSubViews()
        configureUI()
    }
    
    func configureSubViews() {
        view.addSubview(baseView)
        baseView.addSubview(titleTextField)
        baseView.addSubview(categoryTextField)
        baseView.addSubview(touchCategotyButton)
        baseView.addSubview(memoTextView)
        baseView.addSubview(registerButton)
    }
    
    func configureUI() {
        
        baseView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        categoryTextField.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(titleTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        touchCategotyButton.snp.makeConstraints {
            $0.width.equalTo(categoryTextField.snp.width)
            $0.height.equalTo(categoryTextField.snp.height)
            $0.top.equalTo(titleTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(400)
            $0.top.equalTo(categoryTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(50)
//            $0.top.equalTo(memoTextView.snp.bottom).offset(25)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func touchCategory() {
        print(#function)
    }
    
}

extension WritePickMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .label
        textView.text = nil
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "원하는 글을 작성해주세요."
            textView.textColor = .placeholderText
        }
    }
}
