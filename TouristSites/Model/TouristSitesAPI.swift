//
//  TouristSitesManager.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct TouristSites: Codable {
    let result: TouristSiteContent
}

struct TouristSiteContent: Codable {
    let limit, offset, count: Int
    let sort: String
    let results: [TouristSiteResult]
}

struct TouristSiteResult: Codable {
    let info: String?
    let stitle: String
    let longitude: String
    let langinfo: String
    let cat1: String
    let cat2: String
    let file: String
    let latitude: String
    let xbody: String
    let id: Int
    let address: String

    enum CodingKeys: String, CodingKey {
        case info, stitle, longitude, langinfo
        case cat1 = "CAT1"
        case cat2 = "CAT2"
        case file,latitude, xbody
        case id = "_id"
        case address
    }
}

enum TouristSitesAPI: RESTfulRequest {
    
    case getTouristSites(offset: Int, limit: Int)
    
    var url: String {
        switch self {
        case .getTouristSites(let offset, let limit):
            return "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5&limit=\(limit)&offset=\(offset)"
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
