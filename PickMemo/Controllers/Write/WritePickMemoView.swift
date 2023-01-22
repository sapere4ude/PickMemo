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
    
    var isModify: Bool = false
    var selectedIndexPathRow: Int = -1
    var markerVM = MarkerViewModel()
    
    let userInputViewModel = UserInputViewModel()
    let memoVM = MemoViewModel(userInputVM: nil)
    var selectCategoryViewModel : SelectCategoryViewModel? = nil {
        didSet{
            print("WritePickMemoView - selectCategoryViewModel: \(selectCategoryViewModel)")
            self.bind()
        }
    }
    
    var dismissAction = PassthroughSubject<Void, Never>() // 메모 생성 완료 후 첫 뷰컨으로 이동하기 위해 사용
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: PickMemoAction?
    
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
    
    private let titleTextLabel: PaddingLabel = {
        let titleTextLabel = PaddingLabel(withInsets: 10, 10, 10, 10)
        titleTextLabel.backgroundColor = .white
        titleTextLabel.layer.cornerRadius = 15
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = .black
        return titleTextLabel
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
        self.addNotification()
        
        registerButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                // 메모VM에 계속 작성하고 있던 userInput VM을 전달해줘야한다.
                // 그래야 작성된 데이터에 접근하여 메모를 생성할 수 있다
                print(#fileID, #function, #line, "register 버튼 클릭")
                
                if self.isModify {
                    self.memoVM.inputAction.send(.modify(self.userInputViewModel, indexPathRow: self.selectedIndexPathRow))
                } else {
                    self.memoVM.inputAction.send(.create(self.userInputViewModel))
                }
                
                // TODO: - 메모 생성한 뒤에 마커 생성될 수 있도록 액션 주기
                self.markerVM.inputAction.send(.create(self.markerVM.marker!))
                
                // 상위뷰컨으로 넘어갈 수 있도록, 탭바 히든 fasle 처리
                self.dismissAction.send()
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
        self.bind()
        self.addNotification()
    }
    
    private func configureSubViews() {
        self.addSubview(stackView)
        self.addSubview(registerButton)

        [titleTextLabel, categoryLabel, memoTextView].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureUI() {
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(340)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleTextLabel.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(60)
            $0.top.equalTo(titleTextLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(250)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(35)
            //$0.top.equalTo(memoTextView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func configureTapGesutre(target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        categoryLabel.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {

        self.titleTextLabel.text = markerVM.marker?.place
        
        // 뷰모델에 input 넣어주기
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
    
    func modifyMemo(viewModel: MemoViewModel?, indexPath: IndexPath?) {
        if let viewModel = viewModel, let indexPath = indexPath {
            self.titleTextLabel.text = viewModel.memoList[indexPath.row].title
            self.categoryLabel.text = viewModel.memoList[indexPath.row].category
            self.memoTextView.text = viewModel.memoList[indexPath.row].memo
            
            isModify = true
            selectedIndexPathRow = indexPath.row
        }
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


extension WritePickMemoView {
    private func addNotification() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                //self?.writePickMemoView.frame.origin.y -= 20
                
                let keyboardRectangle = value.cgRectValue
                let keyboardHeight = keyboardRectangle.height
//                self?.view.frame.origin.y -= (keyboardHeight-((self?.tabBarController?.tabBar.frame.size.height)!))
                UIView.animate(withDuration: 0.3, animations: {
                        //self?.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
//                    self?.transform = CGAffineTransform(translationX: 0, y: -20)
                    self?.registerButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 40)
                    }
                )
            }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
            .store(in: &subscriptions)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                UIView.animate(withDuration: 0.3, animations: {
                    self?.registerButton.transform = .identity
                    }
                )
            }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
            .store(in: &subscriptions)
    }
}
