//
//  WritePickMemoView.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class WritePickMemoView: UIView {
    
    var isModify: Bool = false
    var selectedIndexPathRow: Int = -1
    var markerVM : MarkerViewModel? = nil {
        didSet{
            print("WritePickMemoView - markerVM didSet: \(markerVM)")
        }
    }
    
    var selectedMemo : Memo? = nil
    
    var selectedMarker : Marker? = nil
    
    let userInputViewModel = UserInputViewModel()
    let memoVM = MemoViewModel(userInputVM: nil)
//    var selectCategoryViewModel : SelectCategoryViewModel? = nil {
//        didSet{
//            //print("WritePickMemoView - selectCategoryViewModel: \(selectCategoryViewModel)")
//            print(#fileID, #function, #line, "칸트, selectCategoryViewModel:\(selectCategoryViewModel)")
//            self.bind()
//        }
//    }
    
    var userCategoryViewModel : UserCategoryViewModel? = nil {
        didSet{
            //print("WritePickMemoView - selectCategoryViewModel: \(selectCategoryViewModel)")
            print(#fileID, #function, #line, "칸트, userCategoryViewModel:\(userCategoryViewModel)")
            self.bind()
        }
    }
    
    var dismissAction = PassthroughSubject<Void, Never>() // 메모 생성 완료 후 첫 뷰컨으로 이동하기 위해 사용
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: PickMemoAction?
    
    var bottomConstraint: NSLayoutConstraint?
    
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
        memoTextView.delegate = self
        return memoTextView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.setTitle("등록하기", for: .normal)
        return button
    }()
    
    convenience init(markerVM: MarkerViewModel,
                     //selectCategoryVM: SelectCategoryViewModel,
                     userCategoryVM: UserCategoryViewModel,
                     selectedMemo: Memo?,
                     selectedMarker: Marker?
    ) {
        //print(#fileID, #function, #line, "-  convenience init markerVM: \(markerVM), selectCategoryVM: \(selectCategoryVM)")
        print(#fileID, #function, #line, "-  convenience init markerVM: \(markerVM), userCategoryVM: \(userCategoryVM)")
        self.init(frame: .zero)
        self.markerVM = markerVM
        self.selectedMemo = selectedMemo
        self.selectedMarker = selectedMarker
        //self.selectCategoryViewModel = selectCategoryVM
        self.userCategoryViewModel = userCategoryVM
        self.initialSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "칸트")
    }
    
    fileprivate func initialSetting(){
        print(#fileID, #function, #line, "- ")
        self.configureSubViews()
        self.configureUI()
        self.bind()
        
        let safeArea = self.safeAreaLayoutGuide
        self.bottomConstraint = NSLayoutConstraint(item: self.registerButton, attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.bottomConstraint?.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        registerButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                // 메모VM에 계속 작성하고 있던 userInput VM을 전달해줘야한다.
                // 그래야 작성된 데이터에 접근하여 메모를 생성할 수 있다
                print(#fileID, #function, #line, "칸트")
                
                if self.isModify {
                    if let selectedMemo = self.selectedMemo {
                        self.memoVM.inputAction
                            .send(.modify(self.userInputViewModel, selectedMemo))
                    }
                } else {
                    #warning("TODO : - 새메모")
                    if let selectedMarker = self.selectedMarker {
                        self.memoVM.inputAction.send(.create(self.userInputViewModel, selectedMarker))
                    }
                    
                    // TODO: - 메모 생성한 뒤에 마커 생성될 수 있도록 액션 주기
                    if self.userInputViewModel.categoryInput.count > 0 {
                        
                        if let markerVM = self.markerVM {
                            markerVM.inputAction.send(.create(markerVM.marker))
                        }
                    }
                }
                // 상위뷰컨으로 넘어갈 수 있도록, 탭바 히든 fasle 처리
                self.dismissAction.send()
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            //$0.width.equalTo(340)
            $0.height.equalTo(35)
            $0.left.right.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureTapGesutre(target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        categoryLabel.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        print(#fileID, #function, #line, "칸트")
        self.titleTextLabel.text = markerVM?.marker.place
        if markerVM?.marker.place != nil {
            userInputViewModel.titleTextInput = markerVM?.marker.place ?? "장소명이 누락되었습니다."
        }
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
//        selectCategoryViewModel?.$selectCategory
//            .print()
//            .receive(on: RunLoop.main)
//            .compactMap{ $0 }
//            .map{ $0.category }
//            .sink {
//                self.categoryLabel.text = $0
//                self.userInputViewModel.categoryInput = self.categoryLabel.text ?? ""
//            }
//            .store(in: &subscriptions)
        
        userCategoryViewModel?.$selectCategory
            .print()
            .receive(on: RunLoop.main)
            .compactMap{ $0 }
            .sink {
                self.categoryLabel.text = $0.categoryIcon + " " + $0.categoryTitle
                print(#fileID, #function, #line, "칸트")
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

extension WritePickMemoView {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - (self.safeAreaInsets.bottom)
            self.bottomConstraint?.constant = -1 * keyboardHeight
            self.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        debugPrint("keyboardWillHide")
        self.bottomConstraint?.constant = 0
        self.layoutIfNeeded()
    }
}

extension WritePickMemoView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "원하는 글을 작성해주세요.") {
            textView.text = ""
        }
    }
}
