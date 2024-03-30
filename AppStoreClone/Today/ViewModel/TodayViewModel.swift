//
//  TodayViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TodayViewModel: Coordinating {
    var coordinator: Coordinator?
    
    struct Input {
    }
    
    struct Output {
        let navigationTitle: String
        let todayMonthAndDate: String
    }
    
    func transform(_ input: TodayViewModel.Input) -> TodayViewModel.Output {
        return TodayViewModel.Output(
            navigationTitle: "투데이",
            todayMonthAndDate: Date().monthAndDate()
        )
    }
}
