//
//  Kingfisher+Wrapper.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func loadFrom(url: String) {
        guard let realUrl = URL(string: url) else { return }
        self.kf.setImage(with: realUrl)
    }
    
}
