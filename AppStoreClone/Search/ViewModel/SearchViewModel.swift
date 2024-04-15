//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import Foundation

final class SearchViewModel: Coordinating {
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
    }
    
    struct Output {
        let navigationTitle: String
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            navigationTitle: "검색"
        )
    }
}
