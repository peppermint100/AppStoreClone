//
//  SearchCollectionViewSection.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import Foundation

struct SearchSectionModel {
    let section: SearchSection
    let items: [SearchItem]
}

enum SearchSection: Hashable {
    case newRecovery(headerText: String)
    case recommendedApps(headerText: String)
}

enum SearchItem: Hashable {
    case term(String)
    case list(ItunesApp)
}
