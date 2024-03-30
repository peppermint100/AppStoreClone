//
//  NetworkingManager.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

enum NetworkingError: Error {
    case invalidUrl
    case invalidStatusCode
    case invalidData
    case failToDecode
}

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        let request = buildRequest(from: url, method: endpoint.method)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                completion(.failure(NetworkingError.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(NetworkingError.failToDecode))
            }
        }
        
        dataTask.resume()
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
