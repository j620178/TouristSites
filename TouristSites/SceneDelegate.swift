//
//  SceneDelegate.swift
//  TouristSites
//
//  Created by littlema on 2019/10/31.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        UIApplication.statusBarFrame = windowScene.statusBarManager?.statusBarFrame
    
        let viewModel = MainViewModel(service: TouristSitesService())
        let vc = MainViewController(viewModel: viewModel)
        let nc = TSNavigationController(rootViewController: vc)

        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        UIApplication.shared.statusBarUIView?.backgroundColor = .tintBlue
    }
    
}

