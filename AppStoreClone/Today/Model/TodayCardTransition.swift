//
//  TodayCardTransition.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import UIKit

final class TodayCardTransition: NSObject {
    let type: TransitionAnimationType
    let item: TodayItem
    
    init(type: TransitionAnimationType!, item: TodayItem!) {
        self.type = type
        self.item = item
    }
}

extension TodayCardTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch item {
        case .big:
            if type == .present {
                presentBigCell(using: transitionContext)
            } else {
                dismissBigCell(using: transitionContext)
            }
        case .banner:
            if type == .present {
                presentBannerCell(using: transitionContext)
            } else {
                dismissBannerCell(using: transitionContext)
            }
        default:
            return
        }
        
    }
}

private extension TodayCardTransition {
    func presentBannerCell(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else { return }
        guard let navigationController = fromVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBannerCell else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? TodayCardViewController else { return }
        
        containerView.addSubview(toVC.view)
        
        let startFrame = selectedCell.convert(selectedCell.appIconContainerView.frame, to: fromVC.view)
        toVC.view.frame = startFrame
        toVC.imageView.frame.size.width = TodayViewController.SizeConstant.bannerCellIconWidth
        toVC.imageView.frame.size.height = TodayViewController.SizeConstant.bannerCellIconWidth
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            toVC.view.frame = UIScreen.main.bounds
            toVC.imageView.frame.size.width = UIScreen.main.bounds.width
            toVC.imageView.frame.size.height = TodayCardViewModel.SizeConstant.imageViewHeight
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: duration - 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            navigationController.navigationBar.frame.origin.y = -UIScreen.main.bounds.size.height
            fromVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissBannerCell(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayCardViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        guard let navigationController = toVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBannerCell else { return }
        
        fromVC.hideCloseButton()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            fromVC.view.frame.origin.y = toVC.view.frame.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: duration - 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            toVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - toVC.tabBar.frame.height
            navigationController.navigationBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

private extension TodayCardTransition {
    func presentBigCell(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else { return }
        guard let navigationController = fromVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBigCell else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? TodayCardViewController else { return }
        
        containerView.addSubview(toVC.view)
        
        let startFrame = selectedCell.convert(selectedCell.bgContainer.frame, to: fromVC.view)
        toVC.view.frame = startFrame
        toVC.imageView.frame.size.width = TodayViewController.SizeConstant.bigCellImageWidth
        toVC.imageView.frame.size.height = TodayViewController.SizeConstant.bigCellImageHeight
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            toVC.view.frame = UIScreen.main.bounds
            toVC.imageView.frame.size.width = UIScreen.main.bounds.width
            toVC.imageView.frame.size.height = TodayCardViewModel.SizeConstant.imageViewHeight
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: duration - 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            navigationController.navigationBar.frame.origin.y = -UIScreen.main.bounds.size.height
            fromVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissBigCell(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayCardViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        guard let navigationController = toVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBigCell else { return }
        
        let frame = selectedCell.convert(selectedCell.bgContainer.frame, to: toVC.view)
        fromVC.hideCloseButton()
        fromVC.clipImage()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            fromVC.view.frame = frame
            fromVC.imageView.frame.size.width = TodayViewController.SizeConstant.bigCellImageWidth
            fromVC.imageView.frame.size.height = TodayViewController.SizeConstant.bigCellImageHeight
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: duration - 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            toVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - toVC.tabBar.frame.height
            navigationController.navigationBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate let duration: TimeInterval = 0.8
