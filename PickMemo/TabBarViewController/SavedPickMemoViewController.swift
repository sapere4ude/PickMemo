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
    var markerVM: MarkerViewModel? = nil
    var memoTest = [Memo]()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(memoViewModel: MemoViewModel, markerViewModel: MarkerViewModel){
        self.init()
        self.memoVM = memoViewModel
        self.markerVM = markerViewModel
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
        memoVM.$memoList
            .bind(subscriber: self.tableView.rowsSubscriber(cellIdentifier: "SavedPickMemoTableViewCell",cellType: SavedPickMemoTableViewCell.self, cellConfig: { cell, indexPath, model in
                cell.selectionStyle = .none
                cell.delegate = self
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memoVM.memoList[indexPath.row]
        
        self.navigationController?.pushViewController(EditPickMemoViewController(viewModel: self.memoVM, selectedMemo: selectedMemo), animated: true)
        
        return
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "지우기") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let memoId = self.memoVM.memoList[indexPath.row].uuid
            self.memoVM.inputAction.send(.delete(memoId))
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        return [deleteAction]
    }
}
