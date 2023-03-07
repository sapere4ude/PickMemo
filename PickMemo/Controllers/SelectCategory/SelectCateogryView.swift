//
//  SelectCateogryView.swift
//  PickMemo
//
//  Created by kant on 2022/12/15.
//

import UIKit
import Combine

final class SelectCategoryView: UIView {

    var selectCategoryViewModel : SelectCategoryViewModel? = nil {
        didSet{
            self.configureBinding()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var selectCategory: [SelectCategory]? = [SelectCategory(category: "🍖 맛집"),
                                             SelectCategory(category: "☕️ 카페"),
                                             SelectCategory(category: "🏖️ 여행"),
                                             SelectCategory(category: "🧘🏻 휴식"),
                                             SelectCategory(category: "📌 기록")]
    
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
    
    // TODO: - 카테고리 만드는 VC로 이동할 수 있게 하는 버튼 생성 필요
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "칸트")
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectCategoryTableViewCell.self,
                           forCellReuseIdentifier: "SelectCategoryTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#fileID, #function, #line, "칸트")
        self.configureSubViews()
        self.configureUI()
        self.configureBinding()
    }
    
    func configureSubViews() {
        self.addSubview(baseView)
        baseView.addSubview(contentsView)
        contentsView.addSubview(titleLabel)
        contentsView.addSubview(tableView)
        contentsView.addSubview(categoryButton)
        categoryButton.addTarget(self, action: #selector(categoryButtonAction), for: .touchUpInside)
    }
    
    @objc func categoryButtonAction() {
        if let vc = self.findViewController() as? SelectCategoryViewController {
            let umcVC = UserMakeCategoryViewController()
            umcVC.modalPresentationStyle = .popover
            //vc.navigationController?.pushViewController(umcVC, animated: true)
            vc.present(umcVC, animated: true)
        }
    }
    
    func configureBinding(){
        print(#fileID, #function, #line, "- ")
        selectCategoryViewModel?
            .$selectCategory // SelectCategory?
            .compactMap{ $0 } // SelectCategory
            .map{ $0.category } // String
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)
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
        
        categoryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    func configureTapGesutre(target: Any?, action: Selector) {
//        let tapGesture = UITapGestureRecognizer(target: target, action: action)
//        baseView.addGestureRecognizer(tapGesture)
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        print("selectCategory index: \(selectCategory![indexPath.row])")
        
        #warning("TODO : - 뷰모델에 선택된 카테고리 알려주기")
        
        selectCategoryViewModel?.selectCategory = selectCategory![indexPath.row]
        
        selectCategoryViewModel?.dismissAction.send(())
        
        return
    }
}
