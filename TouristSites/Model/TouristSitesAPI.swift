//
//  TouristSitesManager.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct URLconstant {
    static var TouristSites = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5"
}

enum TouristSitesAPI: RESTfulRequest {
    
    case getTouristSites(offset: Int, limit: Int)
    
    var url: String {
        switch self {
        case .getTouristSites(let offset, let limit):
            return "\(URLconstant.TouristSites)&limit=\(limit)&offset=\(offset)"
        }
    }
    
    var header: [String : String] {
        return [HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJson.rawValue]
    }
    
    var body: Data? {
        return nil
    }
    
    var method: String {
        return HTTPMethod.GET.rawValue
    }
}
