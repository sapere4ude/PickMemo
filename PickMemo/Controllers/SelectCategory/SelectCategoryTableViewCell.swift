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
    var image: String = ""
}

class SelectCategoryTableViewCell: UITableViewCell {
    
    var selectCategoty: SelectCategory?
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let categoryImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
        configureUI()
    }
    
    func configureSubViews() {
        self.addSubview(categoryImageView)
        self.addSubview(categoryLabel)
    }
    
    func configureUI() {
        categoryImageView.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(35)
            $0.top.equalTo(10)
            $0.left.equalTo(25)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(30)
            $0.left.equalTo(categoryImageView.snp.right).offset(15)
            $0.top.equalTo(10)
        }
    }
    
    func configure(with category: SelectCategory?) {
        if let selectCategoty = category {
            categoryLabel.text = selectCategoty.category
            categoryImageView.image = UIImage(systemName: "\(selectCategoty.image)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
        
}
