//
//  UserMakeCategoryViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/03/06.
//

import UIKit
import Combine

class UserMakeCategoryViewController: UIViewController {
    // TODO: -
    // 여기서 사용자에게 이모지와 카테고리명을 입력받고, 이걸 SelectCategoryView 에 넣어줘야한다.
    // SelectCategoryView 에는 테이블뷰를 넣어줘야 하고
    // 우측 스와이프를 통해 삭제할 수 있는 UI 를 갖게함
    // 카테고리가 하나라도 존재한다면 테이블뷰 하단에 + 버튼 노출, 만약 10개가 된다면 + 버튼 미노출
    // 카테고리 클릭시 카테고리가 아예 없는 경우 테이블뷰를 미노출 시키고 + 버튼을 노출
    
    private var subscriptions = Set<AnyCancellable>()
    var userCategoryViewModel: UserCategoryViewModel!
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가하기", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        return button
    }()
    
    private let emojiLabel: EmojiTextField = {
        let label = EmojiTextField()
        label.clipsToBounds = true
        label.layer.cornerRadius = 75
        label.backgroundColor = .white
        label.textAlignment = .center
        label.tintColor = .green1
        label.font = UIFont.systemFont(ofSize: 40)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.placeholder = "카테고리명을 입력해주세요"
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = rightButton
        textField.delegate = self
        emojiLabel.delegate = self
        emojiLabel.text = userCategoryViewModel.emojiInput
        
        setupUI()
        
        configureTapGesutre()
        
        emojiLabel
            .textFieldInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.emojiInput, on: userCategoryViewModel)
            .store(in: &subscriptions)
        
        textField
            .textFieldInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.categoryInput, on: userCategoryViewModel)
            .store(in: &subscriptions)
        
        userCategoryViewModel.isValidInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: rightButton)
            .store(in: &subscriptions) // 이게 있어야 기능이 동작한다
        
//        userCategoryViewModel.isDuplicate
//            .print()
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.isValid, on: rightButton)
//            .store(in: &subscriptions)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
    @objc private func buttonPressed(_ sender: Any) {
        print(#fileID, #function, #line, "칸트")
        userCategoryViewModel.inputAction.send(.create)
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureTapGesutre() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emojiLabelTouch))
        emojiLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func emojiLabelTouch() {
        emojiLabel.becomeFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
            
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupUI() {
        view.addSubview(emojiLabel)
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            emojiLabel.widthAnchor.constraint(equalToConstant: 150),
            emojiLabel.heightAnchor.constraint(equalToConstant: 150),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 340),
            textField.heightAnchor.constraint(equalToConstant: 60),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
}

extension UserMakeCategoryViewController: UITextFieldDelegate {
    // 리턴 버튼이 눌렸을때
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 둘 중 하나로 키보드를 내릴 수 있다.
//        self.view.endEditing(true)
//        textField.resignFirstResponder()
        
//        return false // 반환 버튼에 기본 동작 구현시 true 아니면 false 라고 공식 문서
//    }
    
    // editing이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 코드
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emojiLabel {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            let maxCharacters = 1
            return updatedText.count <= maxCharacters
        }
        return true
    }
}
