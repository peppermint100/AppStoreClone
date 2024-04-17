//
//  TodayCardCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import UIKit

final class TodayCardCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let app: ItunesApp
    let item: TodayItem
    
    init(navigationController: UINavigationController, app: ItunesApp, item: TodayItem) {
        self.navigationController = navigationController
        self.app = app
        self.item = item
    }
    
    func start() {
        let vc = TodayCardViewController()
        let vm = TodayCardViewModel(coordinator: self, app: app, item: item)
        vc.vm = vm
        navigationController.present(vc, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true) { [weak self] in
            if let self = self {
                self.parent?.childDidFinish(self)
            }
        }
    }
}
