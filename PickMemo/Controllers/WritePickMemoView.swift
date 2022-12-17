//
//  WritePickMemoView.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import Combine

class WritePickMemoView: UIView {
    
    var viewModel: MyViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
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
    
    private lazy var memoTextView: UITextView = {
        let memoTextView = UITextView()
        memoTextView.layer.cornerRadius = 15
        memoTextView.clipsToBounds = true
        memoTextView.backgroundColor = .white
        memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        memoTextView.text = "원하는 글을 작성해주세요."
        memoTextView.textColor = .systemGray
        memoTextView.font = .systemFont(ofSize: 18)
        //memoTextView.delegate = self
        return memoTextView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("등록하기", for: .normal)
        //button.backgroundColor = .systemGray4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubViews()
        self.configureUI()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
        self.bind()
    }
    
    private func configureSubViews() {
        self.addSubview(stackView)
        
        [titleTextField, categoryLabel, memoTextView, registerButton].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureUI() {
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(500)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(titleTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(360)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(35)
            $0.top.equalTo(memoTextView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel = MyViewModel()
        
        titleTextField
            .textFieldInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.titleTextInput, on: viewModel)
            .store(in: &subscriptions)
        
        memoTextView
            .textViewInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.memoTextInput, on: viewModel)
            .store(in: &subscriptions)
        
        // 버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isValidInput
            .print()
            .receive(on: RunLoop.main)
            // 구독
            .assign(to: \.isValid, on: registerButton)
            .store(in: &subscriptions) // 이게 있어야 기능이 동작한다
    }
    
    private func addNotification() {
        
    }
    
    private func removeNotification() {
        
    }
}

extension WritePickMemoView: UITextViewDelegate {
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
