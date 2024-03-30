//
//  Endpoint.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var method: HttpMethod { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL? { get }
}

enum HttpMethod {
    case GET
}
