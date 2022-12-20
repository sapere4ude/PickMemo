//
//  SavedPickMemoTableViewCell.swift
//  PickMemo
//
//  Created by kant on 2022/12/20.
//

import UIKit
import SnapKit

class SavedPickMemoTableViewCell: UITableViewCell {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .systemYellow
        return label
    }()
    
    private let categoryImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemYellow
        return image
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
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryLabel)
    }
    
    func configureUI() {
        contentView.snp.makeConstraints {
            $0.width.centerX.centerY.equalToSuperview()
            $0.height.equalTo(120)
        }
        categoryImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.left.equalTo(35)
            $0.centerY.equalToSuperview().offset(-8)
        }

        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(30)
            $0.left.equalTo(categoryImageView.snp.right).offset(15)
            $0.centerY.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with memo: MemoViewModel?, indexPath: IndexPath) {
        categoryLabel.text = memo?.memoList[indexPath.row].category
    }
}
