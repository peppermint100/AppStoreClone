//
//  TodayCardTransactionManager.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/17/24.
//

import UIKit

enum TransitionType {
    case present
    case dismiss
    
    var blurAlpha: CGFloat { return self == .present ? 1 : 0 }
    var dimAlpha: CGFloat { return self == .present ? 1.0: 0 }
    var cornerRadius: CGFloat { return self == .present ? 20.0 : 0.0 }
    var cardType: CardType { return self == .present ? .cell : .fullSheet }
    var next: TransitionType { return self == .present ? .dismiss : .present }
}

final class TodayCardTransitionManager: NSObject {
    var transitionType: TransitionType = .present
    let transitionDuration: Double = 0.6
    let shrinkDuration: Double = 0.3
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transitionType.next.blurAlpha
        containerView.addSubview(blurEffectView)
        
        whiteView.frame = containerView.frame
        whiteView.alpha = transitionType.next.dimAlpha
        containerView.addSubview(whiteView)
    }
}

extension TodayCardTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        addBackgroundViews(to: containerView)
        
        switch transitionType {
        case .present:
            animatePresent(using: transitionContext)
        case .dismiss:
            animateDismiss(using: transitionContext)
        }
    }
}

extension TodayCardTransitionManager {
    private func animatePresent(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let tabBarVC = transitionContext.viewController(forKey: .from) as? UITabBarController,
              let nav = tabBarVC.viewControllers?.first as? UINavigationController,
              let fromVC = nav.viewControllers.first as? TodayViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? TodayCardViewController,
              let cardView = fromVC.selectedBigCell?.cardView,
              let cardImage = cardView.retriveImage(),
              let cardTitle = cardView.title
        else { return }
        
        let tempCardView = TodayCardView(image: cardImage, title: cardTitle, cardType: transitionType.cardType)
        containerView.addSubview(tempCardView)
        
        let absoluteCardViewFrame = cardView.convert(cardView.frame, to: fromVC.view)
        tempCardView.frame = absoluteCardViewFrame
        tempCardView.layoutIfNeeded()
               
        containerView.addSubview(toVC.view)
        
        cardView.isHidden = true
        toVC.viewsAreHidden = true
        
        animateCardView(cardView: tempCardView, containerView: containerView, yOriginToMoveTo: 0) {
            toVC.viewsAreHidden = false
            toVC.createSnapshotOfView()
            cardView.isHidden = false
            tempCardView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    private func animateDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayCardViewController,
              let tabBarVC = transitionContext.viewController(forKey: .to) as? UITabBarController,
              let nav = tabBarVC.viewControllers?.first as? UINavigationController,
              let toVC = nav.viewControllers.first as? TodayViewController,
              let cell = toVC.selectedBigCell,
              let cardView = cell.cardView,
              let cardImage = fromVC.cardView.image,
              let cardTitle = fromVC.cardView.title
        else { return }
        
        fromVC.viewsAreHidden = true
        let tempCardView = TodayCardView(image: cardImage, title: cardTitle)
        tempCardView.imageView.clipsToBounds = true
        containerView.addSubview(tempCardView)
        tempCardView.frame = CGRect(x: 0, y: 0, width: fromVC.cardView.frame.size.width, height: fromVC.cardView.frame.size.height)
        tempCardView.layoutIfNeeded()
        
        let converted = cardView.convert(cardView.frame, to: nil)
        
        animateCardView(cardView: tempCardView, containerView: containerView,
                        yOriginToMoveTo: converted.origin.y) {
            transitionContext.completeTransition(true)
        }
    }
}

extension TodayCardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animateCardView(cardView: TodayCardView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () -> ()) {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0 ,dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            cardView.imageView.layer.cornerRadius = self.transitionType.next.cornerRadius
            cardView.frame.origin.y = yOriginToMoveTo
            
            self.blurEffectView.alpha = self.transitionType.blurAlpha
            self.whiteView.alpha = self.transitionType.dimAlpha
            cardView.remakeLayout(for: self.transitionType.next.cardType)
            
            cardView.layoutIfNeeded()
        }
        
        animator.addCompletion { _ in
            completion()
        }
        
        animator.startAnimation()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .dismiss
        return self
    }
}
