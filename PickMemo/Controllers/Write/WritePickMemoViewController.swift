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
    
    let selectCategoryViewModel = SelectCategoryViewModel()
    
    private var writePickMemoView = WritePickMemoView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writePickMemoView.selectCategoryViewModel = selectCategoryViewModel
        
        //self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        configureNavigationController()
        configureSubViews()
        configureUI()
        
        writePickMemoView.configureTapGesutre(target: self, action: #selector(touchCategory))
    }
    
    @objc func test() {
        self.navigationController?.popViewController(animated: true)
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
    
    private func configureNavigationController() {
        navigationItem.title = "글 작성하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(test))
        navigationItem.leftBarButtonItem?.tintColor = .systemGray3
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    private func configureSubViews() {
        view.addSubview(writePickMemoView)
    }
    
    private func configureUI() {
        writePickMemoView.snp.makeConstraints {
            $0.width.equalTo(340)
            $0.height.equalTo(700)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func touchCategory() {
        let test = SelectCategoryViewController(vm: selectCategoryViewModel)
        test.modalPresentationStyle = .overFullScreen
        self.present(test, animated: true)
    }
}
