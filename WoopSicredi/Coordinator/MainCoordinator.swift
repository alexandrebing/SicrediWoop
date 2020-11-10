//
//  MainCoordinator.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import UIKit

class MainCoordinator {
    
    private let window: UIWindow
    
    init (window: UIWindow) {
        self.window = window
    }
    func start() {
        let viewController = EventsListViewController.instantiate(viewModel: EventListViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
