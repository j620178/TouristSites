//
//  UICollectionView+Extension.swift
//  TouristSites
//
//  Created by littlema on 2019/10/31.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerWithNib(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
