//
//  TouristSite.swift
//  TouristSites
//
//  Created by littlema on 2019/11/3.
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
