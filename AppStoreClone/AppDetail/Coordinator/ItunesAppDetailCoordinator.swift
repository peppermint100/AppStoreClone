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
    var transition: Bool = false
    
    init(navigationController: UINavigationController, app: ItunesApp, transition: Bool = false) {
        self.navigationController = navigationController
        self.app = app
        self.transition = transition
    }
    
    func start() {
        let vc = ItunesAppDetailViewController()
        let vm = ItunesAppDetailViewModel(coordinator: self, app: app)
        vc.vm = vm
        navigationController.present(vc, animated: true)
    }
}
