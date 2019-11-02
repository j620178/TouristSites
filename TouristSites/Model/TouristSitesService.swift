//
//  TouristSitesService.swift
//  TouristSites
//
//  Created by littlema on 2019/11/3.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class TouristSitesService {
    func getTouristSites(offset: Int, limit: Int = 10, completion: @escaping ResultTouristSite) {
        HTTPClient.shared.request(TouristSitesAPI.getTouristSites(offset: offset, limit: limit)) { result in
            completion(result)
        }
    }
}
