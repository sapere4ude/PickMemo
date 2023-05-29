//
//  HomeViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/05/21.
//

import UIKit
import SnapKit
import RxSwift
import NMapsMap

final class HomeViewController: UIViewController {
    var memoViewModel: MemoViewModel? = nil
    var markerViewModel: MarkerViewModel? = nil
    var naverMapProxy = NaverMapProxy()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(memoViewModel: MemoViewModel, markerViewModel: MarkerViewModel){
        self.init()
        self.memoViewModel = memoViewModel
        self.markerViewModel = markerViewModel
        self.naverMapProxy = NaverMapProxy(markerVM: markerViewModel, memoVM: memoViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
}
