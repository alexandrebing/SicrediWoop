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
    private let navigationController: UINavigationController
    
    init (window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    func start() {
        let viewController = EventsListViewController.instantiate(with: EventListViewModel())
        viewController.coordinator = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func reloadEventListViewController(){
        let vc = EventsListViewController.instantiate(with: EventListViewModel())
        vc.coordinator = self
        var viewcontrollers = self.navigationController.viewControllers
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        self.navigationController.setViewControllers(viewcontrollers, animated: false)
    }
    
    func goToEventDetail(selectedEvent: EventViewModel){
        let detailsViewModel = EventDetailViewModel(selectedEvent: selectedEvent)
        let destinationViewController = EventDetailViewController.instantiate(with: detailsViewModel)
        self.navigationController.pushViewController(destinationViewController, animated: true)
        
    }
}
