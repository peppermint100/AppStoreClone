//
//  TodayCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit

final class TodayCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let vc = TodayViewController()
        let vm = TodayViewModel(coordinator: self, service: ItunesServiceImpl())
        vc.vm = vm
        navigationController.viewControllers = [vc]
    }
    
    func navigateToAppDetail(with app: ItunesApp) {
        let coordinator = ItunesAppDetailCoordinator(navigationController: navigationController, app: app)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func presentCard(with app: ItunesApp, from item: TodayItem) {
        let coordinator = TodayCardCoordinator(navigationController: navigationController, app: app, item: item)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
}