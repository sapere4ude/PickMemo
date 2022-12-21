//
//  WritePickMemoView.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import Combine
import CombineCocoa

class WritePickMemoView: UIView {
    
    let userInputViewModel = UserInputViewModel()
    let memoVM = MemoViewModel(userInputVM: nil)
    var selectCategoryViewModel : SelectCategoryViewModel? = nil {
        didSet{
            print("WritePickMemoView - selectCategoryViewModel: \(selectCategoryViewModel)")
            self.bind()
        }
    }
    
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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubViews()
        self.configureUI()
        self.bind()
        
        registerButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                // 메모VM에 계속 작성하고 있던 userInput VM을 전달해줘야한다.
                // 그래야 작성된 데이터에 접근하여 메모를 생성할 수 있다
                print(#fileID, #function, #line, "kant test!!!")
                self.memoVM.inputAction.send(.create(self.userInputViewModel))
            }
            .store(in: &subscriptions)
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
    
    func configureTapGesutre(target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        categoryLabel.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        
        
        // 뷰모델에 input 넣어주기
        titleTextField
            .textFieldInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.titleTextInput, on: userInputViewModel)
            .store(in: &subscriptions)
        
        memoTextView
            .textViewInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.memoTextInput, on: userInputViewModel)
            .store(in: &subscriptions)
        
        categoryLabel
            .labelInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.categoryInput, on: userInputViewModel)
            .store(in: &subscriptions)
        
        // 버튼이 뷰모델의 퍼블리셔를 구독
        userInputViewModel.isValidInput
            .print()
            .receive(on: RunLoop.main)
            // 구독
            .assign(to: \.isValid, on: registerButton)
            .store(in: &subscriptions) // 이게 있어야 기능이 동작한다
        
        // 뷰모델의 선택된 값을 categoryLabel이 구독할 수 있도록 적용
        // categoryLabel의 값을 userInputViewModel이 가져갈 수 있도록 적용
        selectCategoryViewModel?.$selectCategory
            .print()
            .receive(on: RunLoop.main)
            .compactMap{ $0 }
            .map{ $0.category }
            .sink {
                self.categoryLabel.text = $0
                self.userInputViewModel.categoryInput = self.categoryLabel.text ?? ""
            }
            .store(in: &subscriptions)
    }
}

//extension WritePickMemoView: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        guard textView.textColor == .placeholderText else { return }
//        textView.textColor = .label
//        textView.text = nil
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "원하는 글을 작성해주세요."
//            textView.textColor = .placeholderText
//        }
//    }
//}
