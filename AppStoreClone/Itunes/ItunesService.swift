//
//  ItunesService.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation
import RxSwift

protocol ItunesService {
    func getSoftware(_ endPoint: ItunesEndpoint) -> Observable<ItunesApp>
    func getSoftwares(_ endPoint: ItunesEndpoint) -> Observable<[ItunesApp]>
}

final class ItunesServiceImpl: ItunesService {
    func getSoftware(_ endPoint: ItunesEndpoint) -> Observable<ItunesApp> {
        return NetworkingManager.shared.request(endPoint, type: ItunesResponse.self)
            .map { $0.results.first! }
            .asObservable()
    }
    
    func getSoftwares(_ endPoint: ItunesEndpoint) -> Observable<[ItunesApp]> {
        return NetworkingManager.shared.request(endPoint, type: ItunesResponse.self)
            .map { $0.results }
            .asObservable()
    }
}

enum ItunesEndpoint {
    case today
    case delivery
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
        case .today:
            return .GET
        case .delivery:
            return .GET
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .game:
            return [
                URLQueryItem(name: "term", value: "game"),
                URLQueryItem(name: "limit", value: "5")
            ]
        case .today:
            return [
                URLQueryItem(name: "term", value: "today"),
                URLQueryItem(name: "limit", value: "1")
            ]
        case .delivery:
            return [
                URLQueryItem(name: "term", value: "배달"),
                URLQueryItem(name: "limit", value: "1")
            ]
        }
    }
    
    var url: URL? {
        let baseQueryItems = [URLQueryItem(name: "entity", value: "software"), URLQueryItem(name: "country", value: "kr")]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.path = "/search"
        urlComponents.host = host
        urlComponents.queryItems = queryItems + baseQueryItems
        return urlComponents.url
    }
}
