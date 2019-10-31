//
//  HTTPClient.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case clientError
    case serverError
    case unexpectedError
    case decodeError
}

enum HTTPMethod: String {
    case GET
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
}

enum HTTPHeaderValue: String {
    case applicationJson = "application/json"
}

protocol RESTfulAPIRequest {
    var url: String { get }
    var header: [String: String] { get }
    var body: Data? { get }
    var method: String { get }
}

extension RESTfulAPIRequest {
    func makeRequest() -> URLRequest {
        let realURL = URL(string: url)!
        var request = URLRequest(url: realURL)
        request.allHTTPHeaderFields = header
        request.httpMethod = method
        request.httpBody = body
        return request
    }
}

typealias ResultTouristSite = (Result<TouristSiteContent, HTTPError>) -> Void

class HTTPClient {
    
    static let shared = HTTPClient()
    
    var decoder = JSONDecoder()
    
    func request(_ request: RESTfulAPIRequest,
                 completion: @escaping ResultTouristSite) {

        URLSession.shared.dataTask(with: request.makeRequest(),
                                   completionHandler: { (data, response, error) in
                                    
                                    guard error == nil else {
                                        completion(Result.failure(HTTPError.unexpectedError))
                                        return
                                    }
                                    
                                    guard let httpResponse = response as? HTTPURLResponse else { return }
                                    
                                    let statusCode = httpResponse.statusCode
                                    
                                    switch statusCode {
                                    case 200..<300:
                                        do {
                                            let realData = try self.decoder.decode(TouristSites.self, from: data!)
                                            completion(Result.success(realData.result))
                                        } catch {
                                            completion(Result.failure(HTTPError.decodeError))
                                        }
                                    case 300..<400:
                                        completion(Result.failure(HTTPError.clientError))
                                    case 400..<500:
                                        completion(Result.failure(HTTPError.serverError))
                                    case 500..<600:
                                        completion(Result.failure(HTTPError.unexpectedError))
                                    default:
                                        completion(Result.failure(HTTPError.unexpectedError))
                                    }
                                    
            }).resume()
    }
    
}
