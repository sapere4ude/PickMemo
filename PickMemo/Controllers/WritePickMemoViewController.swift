//
//  WritePickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import Foundation
import UIKit
import SnapKit
import Combine

class WritePickMemoViewController: UIViewController {
    
    private var anyCancellable: AnyCancellable?
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.clipsToBounds = true
        stackView.backgroundColor = .systemGray6
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.backgroundColor = .white
        titleTextField.layer.cornerRadius = 15
        titleTextField.addLeftPadding()
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return titleTextField
    }()
    
    private let categoryLabel: PaddingLabel = {
        let categoryLabel = PaddingLabel(withInsets: 10, 10, 10, 10)
        categoryLabel.backgroundColor = .white
        categoryLabel.layer.cornerRadius = 15
        categoryLabel.clipsToBounds = true
        categoryLabel.textColor = .systemGray
        categoryLabel.text = "카테고리를 선택하세요"
        categoryLabel.isUserInteractionEnabled = true
        return categoryLabel
    }()
    
    private lazy var touchCategotyButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .clear
        button.backgroundColor = .blue
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let keyboardWillShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                let keyboardRectangle = value.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                //self?.view.frame.origin.y -= (keyboardHeight - 30)
                //self?.view.frame.origin.y -= 20
                self?.stackView.frame.origin.y -= 20
            }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
        
        let keyboardWillHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                let keyboardRectangle = value.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                //self?.view.frame.origin.y -= (keyboardHeight - 30)
                self?.stackView.frame.origin.y += 20
            }
//            .map { _ -> CGFloat in 0 }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        navigationItem.title = "저장하기"
        
        configureSubViews()
        configureUI()
        configureGesture()
    }
    
    func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCategory))
        categoryLabel.addGestureRecognizer(tap)
    }
    
    func configureSubViews() {
        view.addSubview(stackView)
        
        [titleTextField, categoryLabel, memoTextView, registerButton].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //categoryTextField.addSubview(touchCategotyButton)
    }
    
    func configureUI() {
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(700)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(titleTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
//        touchCategotyButton.snp.makeConstraints {
//            $0.width.equalTo(categoryTextField.snp.width)
//            $0.height.equalTo(categoryTextField.snp.height)
//            $0.top.equalTo(titleTextField.snp.bottom).offset(25)
//            $0.centerX.equalToSuperview()
//        }
        
        memoTextView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(360)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(50)
            $0.top.equalTo(memoTextView.snp.bottom).offset(25)
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
