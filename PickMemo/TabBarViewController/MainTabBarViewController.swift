//
//  MainTabBarViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    let memoViewModel = MemoViewModel(userInputVM: nil)
    let markerViewModel = MarkerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: PickMemoViewController(memoViewModel: memoViewModel, markerViewModel: markerViewModel))
        
        let vc2 = UINavigationController(rootViewController: SavedPickMemoViewController(memoViewModel: memoViewModel, markerViewModel: markerViewModel))
        
        //let vc3 = UINavigationController(rootViewController: SettingViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        vc2.tabBarItem.image = UIImage(systemName: "bookmark.fill")
        //vc3.tabBarItem.image = UIImage(systemName: "gear")
        
        vc1.title = "지도 보기"
        vc2.title = "저장 목록"
        //vc3.title = "설정하기"

        tabBar.tintColor = .green1
        tabBar.backgroundColor = .white
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
