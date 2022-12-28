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
    private var editPickMemoView = EditPickMemoView()
    
    var viewModel: MemoViewModel?
    var indexPath: IndexPath?
    
    init(viewModel: MemoViewModel, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.indexPath = indexPath
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

        configureNavigationController(title: "글 수정하기")
        
        editPickMemoView = EditPickMemoView(viewModel: viewModel, indexPath: indexPath!)
        
        editPickMemoView.selectCategoryViewModel = selectCategoryViewModel
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        configureSubViews()
        configureUI()
        
        //writePickMemoView.configureTapGesutre(target: self, action: #selector(touchCategory))
        
        editPickMemoView.configureTapGesutre(target: self, action: #selector(touchCategory))
        
        
        editPickMemoView
            .dismissAction
            .sink {
                self.navigationController?.popViewController(animated: true)
                
                DispatchQueue.main.async {
                    self.showToast("ㅋ.ㅋ.ㅋ.ㅋ.ㅋ.ㅋ")
                }
                
                //self.onWillDismiss()

#warning("토스트 메세지가 작성되긴 하지만, 타이밍 이슈가 있음. 뷰컨 팝 된 이후에 토스트 메세지 나올 수 있도록 수정해보기, 그리고 토스트 메세지도 상단쪽에 나올 수 있는 UI로 변경해보기")

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
                //self?.writePickMemoView.frame.origin.y -= 20
                
                let keyboardRectangle = value.cgRectValue
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
                //self?.writePickMemoView.frame.origin.y += 20
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
        //view.addSubview(writePickMemoView)
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
        let test = SelectCategoryViewController(vm: selectCategoryViewModel)
        test.modalPresentationStyle = .overFullScreen
        self.present(test, animated: true)
    }
}

