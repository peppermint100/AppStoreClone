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
    }
    
    func start() {
        let vc = TodayViewController()
        let vm = TodayViewModel(coordinator: self, service: ItunesServiceImpl())
        vc.vm = vm
        navigationController.viewControllers = [vc]
    }
    
    func toAppDetail(with app: ItunesApp, transition: Bool? = false) {
        let coordinator = ItunesAppDetailCoordinator(navigationController: navigationController, app: app, transition: true)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
}
