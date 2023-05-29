//
//  Coordinator.swift
//  PickMemo
//
//  Created by Kant on 2023/05/29.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
