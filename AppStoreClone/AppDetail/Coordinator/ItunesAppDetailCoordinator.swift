//
//  ItunesAppDetailCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/3/24.
//

import UIKit

final class ItunesAppDetailCoordinator: Coordinator {
    var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    let app: ItunesApp
    
    init(navigationController: UINavigationController, app: ItunesApp) {
        self.navigationController = navigationController
        self.app = app
    }
    
    func start() {
        let vc = ItunesAppDetailViewController()
        let vm = ItunesAppDetailViewModel(coordinator: self, app: app)
        vc.hideCloseButton()
        vc.vm = vm
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startWithTransition(item: TodayItem) {
        let vc = ItunesAppDetailViewController()
        let vm = ItunesAppDetailViewModel(coordinator: self, app: app)
        vc.vm = vm
        vc.setTransition(item: item)
        navigationController.present(vc, animated: true)
    }
}
