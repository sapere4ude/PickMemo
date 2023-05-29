//
//  HomeCoordinator.swift
//  PickMemo
//
//  Created by Kant on 2023/05/29.
//

import Foundation
import UIKit

class HomeCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var memoViewModel = MemoViewModel(userInputVM: nil)
    var markerViewModel = MarkerViewModel()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let homeViewController = HomeViewController(memoViewModel: memoViewModel, markerViewModel: markerViewModel)
        homeViewController.view.backgroundColor = .green
        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
