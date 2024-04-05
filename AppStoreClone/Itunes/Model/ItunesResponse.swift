//
//  ItunesResponse.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

// MARK: - AppStoreResponse
struct ItunesResponse: Codable {
    let resultCount: Int
    let results: [ItunesApp]
}
