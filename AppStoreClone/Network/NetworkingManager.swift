//
//  NetworkingManager.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation
import RxSwift

enum NetworkingError: Error {
    case invalidUrl
    case invalidStatusCode
    case invalidData
    case failToBuildRequest
    case failToDecode
}

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type) -> Observable<T> {
        return Observable.create { [weak self] emitter in
            guard let url = endpoint.url else {
                emitter.onError(NetworkingError.invalidUrl)
                return Disposables.create()
            }
            
            guard let request = self?.buildRequest(from: url, method: endpoint.method) else {
                emitter.onError(NetworkingError.failToBuildRequest)
                return Disposables.create()
            }
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    emitter.onError(error!)
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...300) ~= response.statusCode else {
                    emitter.onError(NetworkingError.invalidStatusCode)
                    return
                }
                
                guard let data = data else {
                    emitter.onError(NetworkingError.invalidData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let result = try decoder.decode(T.self, from: data)
                    emitter.onNext(result)
                } catch {
                    print(error)
                    emitter.onError(NetworkingError.failToDecode)
                }
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
    private func buildRequest(from url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch method {
        case .GET:
            request.httpMethod = "GET"
        }
        
        return request
    }
}
