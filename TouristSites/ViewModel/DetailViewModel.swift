//
//  DetailViewModel.swift
//  TouristSites
//
//  Created by littlema on 2019/11/5.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class DetailViewModel {
    
    var titles = ["景點名稱", "景點介紹", "景點資訊", "地點"]
    
    var descs = [String?]()
    
    let photoURLs: [String]
    
    var cellViewModels = [DetailCellViewModel]()
    
    init(descs: [String?], photoURLs: [String]) {
        self.descs = descs
        self.photoURLs = photoURLs
        processCellViewModels()
    }
    
    func processCellViewModels() {
        var cellViewModels = [DetailCellViewModel]()
        for index in titles.indices {
            let cellViewModel = DetailCellViewModel(title: titles[index], desc: descs[index])
            cellViewModels.append(cellViewModel)
        }
        self.cellViewModels = cellViewModels
    }
}
