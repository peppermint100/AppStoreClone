//
//  AppCoordinator.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        self.window = window
    }
    
    func start() {
        let tabVC = UITabBarController()
        
        let todayTabItem = UITabBarItem()
        todayTabItem.title = "투데이"
        todayTabItem.image = Symbols.docTextImage
        
        let todayNVC = UINavigationController()
        todayNVC.tabBarItem = todayTabItem
        
        let todayCoordinator = TodayCoordinator(navigationController: todayNVC)
        todayCoordinator.parent = self
        todayCoordinator.start()
        
        let categoryAppTabItem = UITabBarItem()
        categoryAppTabItem.title = "앱"
        categoryAppTabItem.image = Symbols.squareStackUpFill
        
        let categoryAppNVC = UINavigationController()
        categoryAppNVC.tabBarItem = categoryAppTabItem
        
        let categoryAppCoordinator = CategoryAppCoordinator(navigationController: categoryAppNVC)
        categoryAppCoordinator.parent = self
        categoryAppCoordinator.start()
        
        let searchTabItem = UITabBarItem()
        searchTabItem.title = "검색"
        searchTabItem.image = Symbols.magnifyingglass
        
        let searchNVC = UINavigationController()
        searchNVC.tabBarItem = searchTabItem
        
        let searchCoordinator = SearchCoordinator(navigationController: searchNVC)
        searchCoordinator.parent = self
        searchCoordinator.start()
        
        children.append(todayCoordinator)
        children.append(categoryAppCoordinator)
        children.append(searchCoordinator)
        
        tabVC.viewControllers = [todayNVC, categoryAppNVC, searchNVC]
        
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
    }
}
