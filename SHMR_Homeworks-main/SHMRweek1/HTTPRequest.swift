//
//  HTTPRequest.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 17.07.2024.
//

import Foundation

enum HTTPHandler: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
}

struct HTTPRequest {
    let route: String
    let headers: [String: String]
    let body: Data?
    let queryParams: [(key: String, value: String)]
    let httpHandler: HTTPHandler
    let dateDecoding: JSONDecoder.DateDecodingStrategy
    let keyDecoding: JSONDecoder.KeyDecodingStrategy
    
    init(
        route: String,
        headers: [String: String] = [:],
        body: Data? = nil,
        queryParams: [(key: String, value: String)] = [],
        httpHandler: HTTPHandler = .get,
        dateDecoding: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
        keyDecoding: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) {
        self.route = route
        self.headers = headers
        self.body = body
        self.queryParams = queryParams
        self.httpHandler = httpHandler
        self.dateDecoding = dateDecoding
        self.keyDecoding = keyDecoding
    }
}
