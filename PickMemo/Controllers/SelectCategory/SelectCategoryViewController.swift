//
//  SelectCategoryViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/14.
//

import UIKit
import SnapKit
import Combine

class SelectCategoryViewController: UIViewController {
    
    //private lazy var selectCategoryView = SelectCategoryView()
    
    // TODO: - 이걸 어찌 바꿔야할까나...
    var selectCategoryVM : SelectCategoryViewModel? = nil
    var userCategoryVM : UserCategoryViewModel? = nil
    
    var subscriptions = Set<AnyCancellable>()

    var selectCategory: [SelectCategory]? = [SelectCategory(category: "🍖 맛집"),
                                             SelectCategory(category: "☕️ 카페"),
                                             SelectCategory(category: "🏖️ 여행"),
                                             SelectCategory(category: "🧘🏻 휴식"),
                                             SelectCategory(category: "📌 기록")]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection =  true
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonPressed(_:)))
        return button
    }()
    
//    init(vm: SelectCategoryViewModel) {
//        self.selectCategoryVM = vm
//        super.init(nibName: nil, bundle: nil)
//        print(#fileID, #function, #line, "- self.selectCategoryVM: \(self.selectCategoryVM)")
//    }
    
    init(vm: UserCategoryViewModel) {
        self.userCategoryVM = vm
        super.init(nibName: nil, bundle: nil)
        print(#fileID, #function, #line, "- self.userCategoryVM: \(self.userCategoryVM)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "카테고리 항목"
        self.navigationItem.rightBarButtonItem = rightButton
        
        /*
         SelectCategoryView 는 현재 사용하지 않는 코드
         */
//        selectCategoryView.selectCategoryViewModel = selectCategoryVM
//        selectCategoryView.userCategoryViewModel = userCategoryVM
        
        configureSubViews()
        configureUI()
        
        selectCategoryVM?
            .dismissAction
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print(#fileID, #function, #line, "칸트, 사라짐")
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &subscriptions)
        
        // TODO: - 카테고리 항목 추가했을때 바로 추가되는걸 보여줄 수 있도록 작업
        userCategoryVM?.$categoryList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)

        
        // TODO: - selectCategoryVM 의 .dismissAction 처리를 해줘야함
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectCategoryTableViewCell.self,
                           forCellReuseIdentifier: "SelectCategoryTableViewCell")
    }
    
    func configureSubViews() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    func configureUI() {
        tableView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        let umcVC = UserMakeCategoryViewController()
        umcVC.userCategoryViewModel = userCategoryVM
        self.navigationController?.pushViewController(umcVC, animated: true)
    }
}

extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let selectCategoryCount = selectCategory?.count {
//            return selectCategoryCount
//        } else {
//            return 0
//        }
        
        if let userCategoryCount = userCategoryVM?.categoryList.count {
            return userCategoryCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath) as! SelectCategoryTableViewCell
        
        //cell.configure(with: self.selectCategory?[indexPath.row])
        
        cell.configure(with: self.userCategoryVM?.categoryList[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "칸트")
        
        // TODO: - 선택된 값이 넘어가질 않는 이슈
        // selectCategoryVM? <- 이거를 카테고리 들어올때 정보를 한번 받아오는 역할을 해줘야함
        // MemoViewModel 마냥 처음에 fetch 해주는 메서드 추가해보기
//        selectCategoryVM?.selectCategory = selectCategory![indexPath.row]
//        selectCategoryVM?.dismissAction.send(())
        userCategoryVM?.selectCategory = userCategoryVM?.categoryList[indexPath.row]
        userCategoryVM?.dismissAction.send(())
        return
    }
}
