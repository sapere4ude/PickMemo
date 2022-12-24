//
//  MainTabBarViewController.swift
//  PickMemo
//
//  Created by kant on 2022/12/11.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: PickMemoViewController())
        let vc2 = UINavigationController(rootViewController: SavedPickMemoViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        vc2.tabBarItem.image = UIImage(systemName: "bookmark.fill")
        
        vc1.title = "PickMemo"
        vc2.title = "Saved Pick"
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGray5

        tabBar.layer.cornerRadius = tabBar.frame.height * 0.7
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
