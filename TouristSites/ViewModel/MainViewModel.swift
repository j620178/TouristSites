//
//  HomeViewModel.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var service: TouristSitesService
    
    var touristSites = [TouristSiteResult]()
    
    var offset = 0
            
    let isLoading = Observable<Bool>(value: false)
    
    let isTableViewHidden = Observable<Bool>(value: false)
    
    let cellViewModels = Observable<[TouristSiteCellViewModel]>(value: [])
    
    var numberOfCellViewModels: Int {
        return cellViewModels.value.count
    }
    
    func fetchData() {
        
        guard !isLoading.value else { return }
        
        isLoading.value = true

        offset == 0 ? (isTableViewHidden.value = true) : nil
        
        service.getTouristSites(offset: offset) { [weak self] result in
            
            switch result {
                
            case .success(let data):
                self?.touristSites += data.results
                self?.offset += 10
                self?.processViewModels()
            case .failure(let error):
                print(error)
            }
            
            self?.isLoading.value = false

            self?.isTableViewHidden.value = false
        }
    }
    
    init(service: TouristSitesService) {
        self.service = service
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
    
    func getDetailViewModel(index: Int) -> DetailCellViewModel {
        let touristSite = touristSites[index]
        return DetailCellViewModel(title: touristSite.stitle,
                                   info: touristSite.info,
                                   desc: touristSite.xbody,
                                   longitude: touristSite.longitude,
                                   latitude: touristSite.latitude,
                                   address: touristSite.address,
                                   photoURLs: splitURL(string: touristSite.file))
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
