//
//  MainTabBarViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    // 주입을 위한 메모VM 생성
    let memoViewModel = MemoViewModel(userInputVM: nil)
    
    // 마커VM 가져오기
    let markerViewModel = MarkerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: PickMemoViewController(memoViewModel: memoViewModel, markerViewModel: markerViewModel))
        
        let vc2 = UINavigationController(rootViewController: SavedPickMemoViewController(memoViewModel: memoViewModel, markerViewModel: markerViewModel))
        
        vc1.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        vc2.tabBarItem.image = UIImage(systemName: "bookmark.fill")
        
        vc1.title = "PickMemo"
        vc2.title = "Saved Pick"
        
        //tabBar.tintColor = .black
        tabBar.tintColor = .green1
        //tabBar.backgroundColor = .systemGray5
        tabBar.backgroundColor = .white

//        tabBar.layer.cornerRadius = tabBar.frame.height * 0.7
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
