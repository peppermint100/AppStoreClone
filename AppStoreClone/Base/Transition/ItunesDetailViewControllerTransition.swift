import UIKit
import SnapKit

fileprivate let transitonDuration: TimeInterval = 0.8

class ItunesDetailViewControllerTransition: NSObject {
    let animationType: TransitionAnimationType!
    let item: TodayItem!
    
    init(animationType: TransitionAnimationType, item: TodayItem) {
        self.animationType = animationType
        self.item = item
        super.init()
    }
}

extension ItunesDetailViewControllerTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitonDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch item {
        case .big:
            if animationType == .present {
                presentBigCell(using: transitionContext)
            } else {
                dismissBigCell(using: transitionContext)
            }
        case .banner:
            if animationType == .present {
                presentBannerCell(using: transitionContext)
            } else {
                dismissBannerCell(using: transitionContext)
            }
        default:
            return
        }
    }
}

private extension ItunesDetailViewControllerTransition {
    func presentBannerCell(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else { return }
        guard let navigationController = fromVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBannerCell else { return }
        
        let startFrame = selectedCell.convert(selectedCell.appIconContainerView.frame, to: fromVC.view)
        guard let toVC = transitionContext.viewController(forKey: .to) as? ItunesAppDetailViewController else { return }
        
        guard let cell = toVC.tableView.cellForRow(at: .init(row: 0, section: 0)) as? AppDetailHeadImageTableViewCell
        else { return }
        
        toVC.view.frame = startFrame
        cell.iv.frame.size.width = TodayViewController.SizeConstant.bannerCellIconWidth
        cell.iv.frame.size.height = TodayViewController.SizeConstant.bannerCellIconWidth
        
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitonDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            guard let cell = toVC.tableView.cellForRow(at: .init(row: 0, section: 0)) as? AppDetailHeadImageTableViewCell
            else { return }
            toVC.view.frame = UIScreen.main.bounds
            cell.iv.frame.size.width = UIScreen.main.bounds.width
            cell.iv.frame.size.height = ItunesAppDetailViewModel.SizeConstant.headImageHeight
            navigationController.navigationBar.frame.origin.y = -UIScreen.main.bounds.size.height
            fromVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissBannerCell(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ItunesAppDetailViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        
        UIView.animate(withDuration: transitonDuration - 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            fromVC.view.frame.origin.y = toVC.view.frame.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

private extension ItunesDetailViewControllerTransition {
    
    func presentBigCell(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else { return }
        guard let navigationController = fromVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBigCell else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? ItunesAppDetailViewController else { return }
        
        let startFrame = selectedCell.convert(selectedCell.bgContainer.frame, to: fromVC.view)
        
        guard let cell = toVC.tableView.cellForRow(at: .init(row: 0, section: 0)) as? AppDetailHeadImageTableViewCell
        else { return }
        
        toVC.view.frame = startFrame
        cell.iv.frame.size.width = TodayViewController.SizeConstant.bigCellImageWidth
        cell.iv.frame.size.height = TodayViewController.SizeConstant.bigCellImageHeight
        
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitonDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            guard let cell = toVC.tableView.cellForRow(at: .init(row: 0, section: 0)) as? AppDetailHeadImageTableViewCell
            else { return }
            toVC.view.frame = UIScreen.main.bounds
            cell.iv.frame.size.width = UIScreen.main.bounds.width
            cell.iv.frame.size.height = ItunesAppDetailViewModel.SizeConstant.headImageHeight
            navigationController.navigationBar.frame.origin.y = -UIScreen.main.bounds.size.height
            fromVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
    func dismissBigCell(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ItunesAppDetailViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        guard let navigationController = toVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedBigCell else { return }
        
        guard let appDetailHeadImageCell = fromVC.tableView.cellForRow(at: .init(row: 0, section: 0))
                as? AppDetailHeadImageTableViewCell else {return }
        
        selectedCell.hideViews()
        fromVC.hideCloseButton()
        
        appDetailHeadImageCell.iv.layer.cornerRadius = 20
        appDetailHeadImageCell.iv.clipsToBounds = true
        
        UIView.animate(withDuration: transitonDuration - 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            let frame = selectedCell.convert(selectedCell.bgContainer.frame, to: toVC.view)
            fromVC.view.frame = frame
            navigationController.navigationBar.frame.origin.y = UIScreen.main.bounds.size.height
            appDetailHeadImageCell.iv.frame.size.width = TodayViewController.SizeConstant.bigCellImageWidth
            appDetailHeadImageCell.iv.frame.size.height = TodayViewController.SizeConstant.bigCellImageHeight
            
        }) { (completed) in
            selectedCell.showViews()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: transitonDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            toVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - toVC.tabBar.frame.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
