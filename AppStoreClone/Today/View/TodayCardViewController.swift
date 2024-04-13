//
//  TodayCardViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxGesture

class TodayCardViewController: UIViewController {
    var vm: TodayCardViewModel!
    
    private var draggingDown = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let appItemView = ItunesAppItemView()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 16))
        button.setImage(Symbols.xMark?.withConfiguration(config), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .systemGray4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCloseButton()
        bind()
        bindView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(appItemView)
        contentView.addSubview(descLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(TodayCardViewModel.SizeConstant.imageViewHeight)
        }
        
        appItemView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(TodayCardViewModel.SizeConstant.appItemViewHeight)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(appItemView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.layer.zPosition = 1000
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
        
        closeButton.layer.cornerRadius = 15
        closeButton.clipsToBounds = true
    }
    
    func hideViews() {
        appItemView.isHidden = true
        descLabel.isHidden = true
        closeButton.isHidden = true
    }
    
    func clipImage() {
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    private func bind() {
        let input = TodayCardViewModel.Input(
            closeButtonTapped: closeButton.rx.tap.asObservable()
        )
        let output = vm.transform(input)
        
        let imageUrl = URL(string: output.app.artworkUrl512)
        imageView.kf.setImage(with: imageUrl)
        appItemView.configure(with: output.app)
        descLabel.text = output.app.description
    }
    
    private func bindView() {
        view.rx.panGesture()
            .subscribe(onNext: { [weak self] gesture in
                self?.handlePanGesture(gesture)
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                if contentOffset.y < 0 {
                    self?.draggingDown = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        if !draggingDown { return }
        
        switch panGesture.state {
        case .began, .changed:
            scrollView.isScrollEnabled = false
            scrollView.showsVerticalScrollIndicator = false
            let translation = panGesture.translation(in: view)
            let ratio = imageView.frame.height / (imageView.frame.height + translation.y)
            self.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            
            if ratio < 0.8 {
                vm.dismissDetail()
            }
            
        case .ended, .cancelled:
            scrollView.isScrollEnabled = true
            scrollView.showsVerticalScrollIndicator = true
            draggingDown = false
            let translation = panGesture.translation(in: view)
            let ratio = imageView.frame.height / (imageView.frame.height + translation.y)
            
            if ratio > 0.8 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = .identity
                })
                return
            }
            
            vm.dismissDetail()
        default:
            return
        }
    }
}

extension TodayCardViewController: UIViewControllerTransitioningDelegate {
    
    func setTransition() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TodayCardTransition(type: .present, item: vm.item)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TodayCardTransition(type: .dismiss, item: vm.item)
    }
}

