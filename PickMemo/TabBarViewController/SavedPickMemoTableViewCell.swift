//
//  SavedPickMemoTableViewCell.swift
//  PickMemo
//
//  Created by kant on 2022/12/20.
//

import UIKit
import SnapKit
import SwipeCellKit

class SavedPickMemoTableViewCell: SwipeTableViewCell {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let categoryEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true
        
        configureSubViews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 16, bottom: 10.0, right: 16))
    }
    
    func configureSubViews() {
        contentView.addSubview(categoryEmojiLabel)
        contentView.addSubview(categoryLabel)
    }
    
    func configureUI() {
        contentView.snp.makeConstraints {
            $0.width.centerX.centerY.equalToSuperview()
            $0.height.equalTo(120)
        }
        categoryEmojiLabel.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.left.equalTo(35)
            $0.centerY.equalToSuperview().offset(-8)
        }

        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(30)
            $0.left.equalTo(categoryEmojiLabel.snp.right).offset(15)
            $0.centerY.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with memo: Memo) {
        if let emoji = memo.category?.first {
            categoryEmojiLabel.text = String(emoji)
        }
        categoryLabel.text = memo.title
    }
}
