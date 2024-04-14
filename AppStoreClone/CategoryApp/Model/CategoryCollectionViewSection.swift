//
//  CategoryCollectionViewSection.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/13/24.
//

import Foundation

struct CategorySectionModel {
    let section: CategorySection
    let items: [CategoryItem]
}

enum CategorySection: Hashable {
    case photo(headerTitle: String, headerSubtitle: String)
    case map(headerTitle: String, headerSubtitle: String)
    case note(headerTitle: String, headerSubtitle: String)
    case watch(headerTitle: String, headerSubtitle: String)
}

enum CategoryItem: Hashable {
    case horizontalList(ItunesApp)
    case gradientBackgroundList(ItunesApp)
}
