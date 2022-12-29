//
//  SavedPickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit
import Combine
import SnapKit
import SwipeCellKit
import CombineDataSources

class SavedPickMemoViewController: UIViewController {
    
    var memoVM = MemoViewModel(userInputVM: nil)
    var memoTest = [Memo]()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(memoViewModel: MemoViewModel){
        self.init()
        self.memoVM = memoViewModel
        print(#fileID, #function, #line, "kant test")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.allowsSelection =  true
        tableView.allowsMultipleSelectionDuringEditing = true
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
        //tableView.dataSource = self // combine datasource 사용했기 때문에 괜찮음

        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memoVM.inputAction.send(.fetch)
        //self.bind() // 여기에 bind 있으면 인덱스 오류남
    }
    
    func configureSubViews() {
        view.addSubview(tableView)
    }
    
    func configureUI() {
        tableView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
    }
    
    func bind() {
   //        memoVM.$memoList
   //            .receive(on: DispatchQueue.main)
   //            .sink { _ in
   //                self.tableView.reloadData()
   //            }
   //            .store(in: &subscriptions)
           
           memoVM.$memoList
               .bind(subscriber: self.tableView.rowsSubscriber(cellIdentifier: "SavedPickMemoTableViewCell",cellType: SavedPickMemoTableViewCell.self, cellConfig: { cell, indexPath, model in
                 cell.selectionStyle = .none
                 cell.delegate = self
//                   cell.configure(with: self.memoVM, indexPath: indexPath)
                 cell.configure(with: model)
             }))
             .store(in: &subscriptions)
       }
}

extension SavedPickMemoViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 전달받은 값을 카운팅해야 하는데 최초에 받은 값에 대해서만 카운팅하는게 문제였던 것 같음
        return memoVM.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPickMemoTableViewCell", for: indexPath) as! SavedPickMemoTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        //cell.configure(with: memoVM, indexPath: indexPath)
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
        
        //self.navigationController?.pushViewController(WritePickMemoViewController, animated: true)

        
        
        // 수정 액션
        // 현재 인덱스의 데이터를 가져오기
        //self.memoVM.inputAction.send(.modify(indexPath.row))
        // 뷰컨 띄워주면서 정보 입력될 수 있도록 하기
        
//        self.navigationController?.pushViewController(WritePickMemoViewController(viewModel: self.memoVM, indexPath: indexPath), animated: true)
        
        self.navigationController?.pushViewController(EditPickMemoViewController(viewModel: self.memoVM, indexPath: indexPath), animated: true)
        
        return
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "지우기") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            // 뷰모델에 알리기
            self.memoVM.inputAction.send(.delete(indexPath.row))
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        return [deleteAction]
    }
}
