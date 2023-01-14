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
    
    let selectCategoryViewModel = SelectCategoryViewModel()
    
    lazy var writePickMemoView = WritePickMemoView()

    var markerInfo: [String: String] = ["":""]

    var viewModel: MemoViewModel?
    var markerVM: MarkerViewModel?
    var indexPath: IndexPath?

    init(markerVM: MarkerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.markerVM = markerVM
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
        configureNavigationController(title: "글 작성하기")
        
        writePickMemoView = WritePickMemoView()
        writePickMemoView.markerVM = self.markerVM!
        writePickMemoView.selectCategoryViewModel = selectCategoryViewModel
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray6
        configureSubViews()
        configureUI()
        
        writePickMemoView.configureTapGesutre(target: self, action: #selector(touchCategory))
        
        writePickMemoView
            .dismissAction
            .sink {
                self.navigationController?.showToast("메모 저장 완료")
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &subscriptions)
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
                //self?.writePickMemoView.frame.origin.y -= 20
                
                let keyboardRectangle = value.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
//                self?.view.frame.origin.y -= (keyboardHeight-((self?.tabBarController?.tabBar.frame.size.height)!))
                UIView.animate(withDuration: 0.3, animations: {
                        //self?.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
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
    
    private func configureNavigationController(title: String) {
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(test))
        navigationItem.leftBarButtonItem?.tintColor = .systemGray3
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    private func configureSubViews() {
        view.addSubview(writePickMemoView)
    }
    
    private func configureUI() {
        writePickMemoView.snp.makeConstraints {
//            $0.width.equalTo(340)
//            $0.height.equalTo(700)
//            $0.centerX.equalToSuperview()
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func onWillDismiss() {
        navigationController?.popViewController(animated: true)
        //tabBarController?.tabBar.isHidden = false
    }
    
    @objc func touchCategory() {
        let test = SelectCategoryViewController(vm: selectCategoryViewModel)
        test.modalPresentationStyle = .overFullScreen
        self.present(test, animated: true)
    }
}
