//
//  SavedPickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit
import Combine
import SnapKit


class SavedPickMemoViewController: UIViewController {
    
    var memoVM = MemoViewModel(vm: nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection =  true
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "저장 목록"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemGray6
        configureSubViews()
        configureUI()
        
        tableView.register(SavedPickMemoTableViewCell.self,
                           forCellReuseIdentifier: "SavedPickMemoTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let memo = UserDefaultsManager.shared.getMemoList() ?? [Memo]() // [Memo]
        
        memoVM.memoList = memo
    }
    
    func configureSubViews() {
        view.addSubview(tableView)
    }
    
    func configureUI() {
        tableView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
    }
}

extension SavedPickMemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoVM.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPickMemoTableViewCell", for: indexPath) as! SavedPickMemoTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: memoVM, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#function)
//        print("selectCategory index: \(selectCategory![indexPath.row])")
//
//        #warning("TODO : - 뷰모델에 선택된 카테고리 알려주기")
//
//        selectCategoryViewModel?.selectCategory = selectCategory![indexPath.row]
//
//        selectCategoryViewModel?.dismissAction.send(())
        
        return
    }
    
}
