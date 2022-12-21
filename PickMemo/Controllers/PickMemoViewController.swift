//
//  PickMemoViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit
import SnapKit

class PickMemoViewController: UIViewController {
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackThree
        view.alpha = 0.6
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var sampleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(sampleButton)
        
        sampleButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func pressedButton() {
        // writePickMemoViewController
        self.navigationController?.pushViewController(WritePickMemoViewController(viewModel: nil, indexPath: nil), animated: true)

        // UI test
//        let test = SelectCategoryViewController()
//        test.modalPresentationStyle = .overFullScreen
//        self.present(test, animated: true)
    }
}
