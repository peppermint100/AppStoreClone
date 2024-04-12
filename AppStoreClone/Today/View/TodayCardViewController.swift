//
//  TodayCardViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import UIKit
import SnapKit
import Kingfisher

class TodayCardViewController: UIViewController {
    var vm: TodayCardViewModel!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        configure()
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
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    func hideCloseButton() {
        closeButton.isHidden = true
    }
    
    func clipImage() {
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    private func configure() {
        let input = TodayCardViewModel.Input()
        let output = vm.transform(input)
        
        let imageUrl = URL(string: output.app.artworkUrl512)
        imageView.kf.setImage(with: imageUrl)
        appItemView.configure(with: output.app)
        descLabel.text = output.app.description
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

