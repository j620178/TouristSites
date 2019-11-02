//
//  HomeViewModel.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var manager: TouristSitesManager
    
    var touristSites = [TouristSiteResult]()
    
    var offset = 0
    
    let isLoading = Observable<Bool>(value: false)
    
    let isTableViewHidden = Observable<Bool>(value: false)
    
    let cellViewModels = Observable<[TouristSiteCellViewModel]>(value: [])
    
    var cellViewModelsCount: Int {
        return cellViewModels.value.count
    }
    
    func fetchData() {
        isLoading.value = true
        
        isTableViewHidden.value = true
        
        manager.getTouristSites(offset: 0, limit: 0) { [weak self] result in
            
            switch result {
                
            case .success(let data):
                self?.touristSites = data.results
                self?.offset = data.offset
                self?.processViewModels()
            case .failure(let error):
                print(error)
            }
            
            self?.isLoading.value = false
            
            self?.isTableViewHidden.value = false
        }
    }
    
    init(manager: TouristSitesManager) {
        self.manager = manager
    }
    
    func processViewModels() {
        var cellViewModels = [TouristSiteCellViewModel]()
        
        for touristSite in touristSites {
            cellViewModels.append(TouristSiteCellViewModel(title: touristSite.stitle, desc: touristSite.xbody, photoURL: splitURL(string: touristSite.file)))
        }
        
        self.cellViewModels.value = cellViewModels
    }
    
    func getViewModel(index: Int) -> TouristSiteCellViewModel {
        return cellViewModels.value[index]
    }
    
    func splitURL(string: String) -> [String] {
        var urls = string.components(separatedBy: "http")
        
        for index in urls.indices.reversed() {
            if urls[index] == "" {
                urls.remove(at: index)
            } else {
                urls[index] = "http" + urls[index]
            }
        }
        
        return urls.filter { $0.contains("jpg") || $0.contains("JPG") || $0.contains("jpeg") || $0.contains("JPEG") }
    }
    
}
