//
//  SearchCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let vc = SearchViewController()
        let vm = SearchViewModel(coordinator: self, service: ItunesServiceImpl())
        vc.vm = vm
        navigationController.viewControllers = [vc]
    }
    
    func navigateToDetail(app: ItunesApp) {
        let coordinator = ItunesAppDetailCoordinator(navigationController: navigationController, app: app)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
}
