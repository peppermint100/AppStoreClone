//
//  CategoryAppCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/13/24.
//

import UIKit

final class CategoryAppCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let vc = CategoryAppViewController()
        let service = ItunesServiceImpl()
        let vm = CategoryAppViewModel(coordinator: self, service: service)
        vc.vm = vm
        navigationController.viewControllers = [vc]
    }
}
