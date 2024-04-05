import UIKit
import SnapKit

fileprivate let transitonDuration: TimeInterval = 1

class TodayBigCellTransition: NSObject {
    let animationType: TransitionAnimationType!
    
    var contentViewTopAnchor: NSLayoutConstraint!
     var contentViewWidthAnchor: NSLayoutConstraint!
     var contentViewHeightAnchor: NSLayoutConstraint!
     var contentViewCenterXAnchor: NSLayoutConstraint!
     
     var subDescTopAnchor: NSLayoutConstraint!
     var subDescLeadingAnchor: NSLayoutConstraint!
     
     var descTopAnchor: NSLayoutConstraint!
     var descLeadingAnchor: NSLayoutConstraint!
    
    init(animationType: TransitionAnimationType) {
        self.animationType = animationType
        super.init()
    }
}

extension TodayBigCellTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitonDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if animationType == .present {
            animationForPresent(using: transitionContext)
        } else {
            animationForDismiss(using: transitionContext)
        }
    }
    
    func animationForPresent(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else { return }
        guard let navigationController = fromVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedCell else { return }
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
    
    
    func animationForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ItunesAppDetailViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        guard let navigationController = toVC.viewControllers?.first as? UINavigationController else { return }
        guard let tableViewController = navigationController.viewControllers.first as? TodayViewController else { return }
        guard let selectedCell = tableViewController.selectedCell else { return }
        
        guard let appDetailHeadImageCell = fromVC.tableView.cellForRow(at: .init(row: 0, section: 0))
                as? AppDetailHeadImageTableViewCell else {return }
        
        selectedCell.hideViews()
        fromVC.hideViews()
        
        UIView.animate(withDuration: transitonDuration - 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            let frame = selectedCell.convert(selectedCell.bgContainer.frame, to: toVC.view)
            fromVC.view.frame = frame
            appDetailHeadImageCell.iv.frame.size.width = TodayViewController.SizeConstant.bigCellImageWidth
            appDetailHeadImageCell.iv.frame.size.height = TodayViewController.SizeConstant.bigCellImageHeight
            appDetailHeadImageCell.iv.layer.cornerRadius = 20
            appDetailHeadImageCell.iv.clipsToBounds = true
        }) { (completed) in
            selectedCell.showViews()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: transitonDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            navigationController.navigationBar.frame.origin.y = UIScreen.main.bounds.size.height
            toVC.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - toVC.tabBar.frame.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
