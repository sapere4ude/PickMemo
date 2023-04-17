//
//  SelectCategoryTableViewCell.swift
//  PickMemo
//
//  Created by kant on 2022/12/17.
//

import UIKit
import SnapKit

struct SelectCategory {
    var category: String = ""
}

class SelectCategoryTableViewCell: UITableViewCell {
    
    var selectCategoty: SelectCategory?
    
    var userCategory: UserCategory?
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
        configureUI()
    }
    
    func configureSubViews() {
        self.addSubview(categoryLabel)
    }
    
    func configureUI() {
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(30)
            $0.left.equalTo(25)
            $0.centerY.equalToSuperview()
        }
    }
    
//    func configure(with category: SelectCategory?) {
    func configure(with category: UserCategory?) {
//        if let selectCategoty = category {
//            categoryLabel.text = selectCategoty.category
//        }
        
        if let userCategory = category {
            categoryLabel.text = userCategory.categoryIcon + " " + userCategory.categoryTitle 
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
