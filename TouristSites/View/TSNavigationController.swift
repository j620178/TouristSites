//
//  TSNavigationController.swift
//  TouristSites
//
//  Created by littlema on 2019/11/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TSNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = .tintBlue
        self.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = textAttributes
    }

}
