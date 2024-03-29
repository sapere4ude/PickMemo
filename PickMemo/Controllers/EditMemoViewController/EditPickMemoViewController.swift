//
//  EditPickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/24.
//

import UIKit
import SnapKit
import Combine

class EditPickMemoViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    let selectCategoryViewModel = SelectCategoryViewModel()
    let userCategoryViewModel = UserCategoryViewModel()
    private var editPickMemoView = EditPickMemoView()
    
    var viewModel: MemoViewModel?
    var indexPath: IndexPath?
    
    var selectedMemo: Memo?
    
    init(viewModel: MemoViewModel, selectedMemo: Memo) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
//        self.indexPath = indexPath
        self.selectedMemo = selectedMemo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //addNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationController(title: "메모 보기")
        
        if let selectedMemo = self.selectedMemo {
            editPickMemoView = EditPickMemoView(viewModel: viewModel, selectedMemo: selectedMemo)
        }
        
        editPickMemoView.selectCategoryViewModel = selectCategoryViewModel
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        configureSubViews()
        configureUI()
        
        editPickMemoView.configureTapGesutre(target: self, action: #selector(touchCategory))
        
        editPickMemoView
            .dismissAction
            .sink {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.showToast("메모 수정 완료")
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotification() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue) }
            .map { [weak self] value in
                _ = value.cgRectValue
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.transform = CGAffineTransform(translationX: 0, y: -20)
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
                self?.editPickMemoView.frame.origin.y += 20
            }
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: {
                print("receive Value")
            })
            .store(in: &subscriptions)
    }

    @objc func test() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigationController(title: String) {
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(test))
        navigationItem.leftBarButtonItem?.tintColor = .systemGray3
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    private func configureSubViews() {
        view.addSubview(editPickMemoView)
    }
    
    private func configureUI() {
        editPickMemoView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func onWillDismiss() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func touchCategory() {
        let test = SelectCategoryViewController(vm: userCategoryViewModel)
        test.modalPresentationStyle = .overFullScreen
        self.present(test, animated: true)
    }
}

