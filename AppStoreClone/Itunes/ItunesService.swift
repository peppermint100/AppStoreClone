//
//  ItunesService.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

protocol ItunesService {
    func getSoftwares()
}

final class ItunesServiceImpl: ItunesService {
    
    func getSoftwares() {
        NetworkingManager.shared.request(ItunesEndpoint.game, type: ItunesResponse.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

enum ItunesEndpoint {
    case game
}

extension ItunesEndpoint: Endpoint {
    var host: String {
        "itunes.apple.com"
    }
    
    var method: HttpMethod {
        switch self {
        case .game:
            return .GET
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .game:
            return [
                URLQueryItem(name: "term", value: "game")
            ]
        }
    }
    
    var url: URL? {
        let baseQueryItems = [URLQueryItem(name: "entity", value: "software"), URLQueryItem(name: "limit", value: "3")]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.path = "/search"
        urlComponents.host = host
        urlComponents.queryItems = queryItems + baseQueryItems
        return urlComponents.url
    }
}
