//
//  UserMakeCategoryViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/03/06.
//

import UIKit

class UserMakeCategoryViewController: UIViewController {
    // TODO: -
    // 여기서 사용자에게 이모지와 카테고리명을 입력받고, 이걸 SelectCategoryView 에 넣어줘야한다.
    // SelectCategoryView 에는 테이블뷰를 넣어줘야 하고
    // 우측 스와이프를 통해 삭제할 수 있는 UI 를 갖게함
    // 카테고리가 하나라도 존재한다면 테이블뷰 하단에 + 버튼 노출, 만약 10개가 된다면 + 버튼 미노출
    // 카테고리 클릭시 카테고리가 아예 없는 경우 테이블뷰를 미노출 시키고 + 버튼을 노출
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        textField.delegate = self
        textField.becomeFirstResponder()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            emojiLabel.widthAnchor.constraint(equalToConstant: 50),
            emojiLabel.heightAnchor.constraint(equalToConstant: 50),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 100),
            textField.heightAnchor.constraint(equalToConstant: 100),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension UserMakeCategoryViewController: UITextFieldDelegate {
    // 리턴 버튼이 눌렸을때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 둘 중 하나로 키보드를 내릴 수 있다.
        self.view.endEditing(true)
        textField.resignFirstResponder()
        
        return false // 반환 버튼에 기본 동작 구현시 true 아니면 false 라고 공식 문서
    }
    
    // editing이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 코드
    }
}
