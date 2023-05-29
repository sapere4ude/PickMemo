//
//  AppCoordinator.swift
//  PickMemo
//
//  Created by Kant on 2023/05/29.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {
    
    private var navigationController: UINavigationController!
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeViewController()
    }
    
    private func showHomeViewController() {
        let coordinator = HomeCoordinator(navigationController:self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
