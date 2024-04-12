//
//  TodayCardViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import Foundation

final class TodayCardViewModel: Coordinating {
    var coordinator: Coordinator
    var app: ItunesApp
    var item: TodayItem
    
    init(coordinator: Coordinator, app: ItunesApp, item: TodayItem) {
        self.coordinator = coordinator
        self.app = app
        self.item = item
    }
    
    struct Input {
    }
    
    struct Output {
        let app: ItunesApp
    }
    
    func transform(_ input: TodayCardViewModel.Input) -> TodayCardViewModel.Output {
        return TodayCardViewModel.Output(
            app: self.app
        )
    }
}

extension TodayCardViewModel {
    enum SizeConstant {
        static let imageViewHeight: CGFloat = 400
        static let appItemViewHeight: CGFloat = 120
    }
}
