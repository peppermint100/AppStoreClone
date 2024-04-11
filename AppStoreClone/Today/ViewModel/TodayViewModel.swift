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
    var coordinator: Coordinator
    let service: ItunesService
    
    init(coordinator: Coordinator, service: ItunesService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    struct Input {
    }
    
    struct Output {
        let navigationTitle: String
        let todaysApp: Observable<ItunesApp>
        let deliveryApp: Observable<ItunesApp>
        let gameApps: Observable<[ItunesApp]>
    }
    
    func transform(_ input: TodayViewModel.Input) -> TodayViewModel.Output {
        let todaysApp = service.getSoftware(.today)
        let deliveryApp = service.getSoftware(.delivery)
        let gameApps = service.getSoftwares(.game)
        
        return TodayViewModel.Output(
            navigationTitle: "투데이",
            todaysApp: todaysApp,
            deliveryApp: deliveryApp,
            gameApps: gameApps
        )
    }
    
    func didTapCell(with app: ItunesApp) {
        guard let coordinator = coordinator as? TodayCoordinator else { return }
        coordinator.openAppDetail(with: app)
    }
    
    func transitionToDetail(with app: ItunesApp, from item: TodayItem) {
        guard let coordinator = coordinator as? TodayCoordinator else { return }
        coordinator.openAppDetailWithTransition(with: app, from: item)
    }
}
