//
//  WritePickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit
import SnapKit
import Combine

class WritePickMemoViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    var viewModel: MyViewModel!
    private var writePickMemoView = WritePickMemoView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        navigationItem.title = "저장하기"
        
        configureSubViews()
        configureUI()
        //configureGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotification() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                self?.writePickMemoView.frame.origin.y -= 20
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
                self?.writePickMemoView.frame.origin.y += 20
            }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
            .store(in: &subscriptions)
    }
    
//    private func configureGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCategory))
//        categoryLabel.addGestureRecognizer(tap)
//    }
    
    private func configureSubViews() {
        view.addSubview(writePickMemoView)
    }
    
    private func configureUI() {
        writePickMemoView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(500)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func touchCategory() {
        print(#function)
    }
}
