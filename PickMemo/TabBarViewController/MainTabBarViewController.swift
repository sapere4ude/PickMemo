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
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        
        tabBar.tintColor = .black
        setViewControllers([vc1, vc2], animated: true)
    }
}
