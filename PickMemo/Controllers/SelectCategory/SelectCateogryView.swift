//
//  SelectCateogryView.swift
//  PickMemo
//
//  Created by kant on 2022/12/15.
//

import UIKit
import Combine

final class SelectCategoryView: UIView {
    
    let selectCategoryViewModel = SelectCategoryViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    var selectCategory: [SelectCategory]? = [SelectCategory(category: "맛집", image: "heart.fill"),
                                             SelectCategory(category: "카페", image: "ellipsis.bubble"),
                                             SelectCategory(category: "휴식", image: "tortoise")]
    
    private let baseView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .systemBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리를 선택해주세요"
        label.font = .boldSystemFont(ofSize: 18)
        label.isUserInteractionEnabled = true
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layer.cornerRadius = 20
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.clipsToBounds = true
        stackView.backgroundColor = .systemBackground
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection =  true
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubViews()
        self.configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectCategoryTableViewCell.self,
                           forCellReuseIdentifier: "SelectCategoryTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
    }
    
    func configureSubViews() {
        self.addSubview(baseView)
        baseView.addSubview(contentsView)
        contentsView.addSubview(titleLabel)
        contentsView.addSubview(tableView)
    }
    
    func configureUI() {
        baseView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(271)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(240)
        }
    }
    
    func configureTapGesutre(target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        baseView.addGestureRecognizer(tapGesture)
    }
}

extension SelectCategoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectCategoryCount = selectCategory?.count {
            return selectCategoryCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath) as! SelectCategoryTableViewCell
        
        cell.configure(with: self.selectCategory?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        print("selectCategory index: \(selectCategory![indexPath.row])")
        
        titleLabel
            .selectCategoryPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectCategory, on: selectCategoryViewModel)
            .store(in: &subscriptions)
        
        return
    }
}
