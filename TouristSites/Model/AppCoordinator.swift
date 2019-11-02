//
//  Coordinator.swift
//  TouristSites
//
//  Created by littlema on 2019/11/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
        
    func start()
}

class AppCoordinator: Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    var navigationController = TSNavigationController()
    
    var window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func start() {
        let viewModel = MainViewModel(service: TouristSitesService())
        let viewController = MainViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        navigationController.viewControllers.append(viewController)

        window.rootViewController = navigationController
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension AppCoordinator: MainViewControllerCoordinatorDelegate {
    func showDetailFrom(_ viewController: UIViewController, viewModel: DetailViewModel) {
        
        let nextVC = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(nextVC, animated: true)
    }
}
