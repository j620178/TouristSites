//
//  HomeViewModel.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class MainViewModel {
    
    let service: TouristSitesService
    
    let state = Observable<MainViewState>(value: .empty)
    
    private var touristSites = [TouristSiteResult]()
    
    private var offset = 0
    
    let cellViewModels = Observable<[MainCellViewModel]>(value: [])
    
    var numberOfCellViewModels: Int {
        return cellViewModels.value.count
    }
    
    init(service: TouristSitesService) {
        self.service = service
    }
    
    private func enableFetch() -> Bool {
        switch state.value {
        case .normal(let isEnd):
            return isEnd ? false : true
        case .loading:
            return false
        default:
            return true
        }
    }
    
    func fetchData() {
        
        guard enableFetch() else { return }
        
        state.value = .loading(isLoadMore: numberOfCellViewModels != 0)
        
        service.getTouristSites(offset: offset) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.touristSites += data.results
                
                if data.results.count > 0 {
                    let isEnd = (strongSelf.offset + 10) > data.count
                    strongSelf.state.value = .normal(isEnd: isEnd)
                    strongSelf.offset += 10
                } else {
                    strongSelf.state.value = .empty
                }
                
                self?.processViewModels()
            
            case .failure:
                self?.state.value = .apiError
            }
        }
    }
    
    func getViewModel(index: Int) -> MainCellViewModel {
        return cellViewModels.value[index]
    }
    
    func getDetailViewModel(index: Int) -> DetailViewModel {
        let touristSite = touristSites[index]
        
        return DetailViewModel(descs: [touristSite.stitle,
                                       touristSite.info,
                                       touristSite.xbody,
                                       touristSite.address],
                               photoURLs: splitURL(string: touristSite.file))
    }
    
    func getTouristSite(index: Int) -> TouristSiteResult {
        return touristSites[index]
    }
    
    private func processViewModels() {
        var cellViewModels = [MainCellViewModel]()
        
        for touristSite in touristSites {
            cellViewModels.append(MainCellViewModel(title: touristSite.stitle, desc: touristSite.xbody, photoURL: splitURL(string: touristSite.file)))
        }
        
        self.cellViewModels.value = cellViewModels
    }
    
    private func splitURL(string: String) -> [String] {
        var urls = string.components(separatedBy: "http")
        
        for index in urls.indices.reversed() {
            if urls[index] == "" {
                urls.remove(at: index)
            } else {
                urls[index] = "http" + urls[index]
            }
        }
        
        return urls.filter { $0.contains("jpg") || $0.contains("JPG") || $0.contains("jpeg") || $0.contains("JPEG") || $0.contains("png") || $0.contains("PNG") }
    }
    
}
