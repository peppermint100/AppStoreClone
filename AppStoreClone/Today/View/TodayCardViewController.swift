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
    
    var viewsAreHidden: Bool = false {
        didSet {
            cardView.isHidden = viewsAreHidden
            appItemView.isHidden = viewsAreHidden
            descLabel.isHidden = viewsAreHidden
            closeButton.isHidden = viewsAreHidden
            
            view.backgroundColor = viewsAreHidden ? .clear : .systemBackground
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let disposeBag = DisposeBag()
    
    let cardView = TodayCardView(cardType: .fullSheet)
    private let appItemView = ItunesAppItemView()
    
    lazy var snapshotView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOffset = CGSize(width: -1, height: 2)
        imageView.isHidden = true
        return imageView
    }()
    
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
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = true
        
        contentView.addSubview(cardView)
        contentView.addSubview(appItemView)
        contentView.addSubview(descLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(TodayCardViewModel.SizeConstant.imageViewHeight)
        }
        
        appItemView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cardView.snp.bottom)
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
    
    private func bind() {
        let input = TodayCardViewModel.Input(
            closeButtonTapped: closeButton.rx.tap.asObservable()
        )
        let output = vm.transform(input)
        
        let imageUrl = URL(string: output.app.artworkUrl512)
        cardView.configure(imageUrlString: output.app.artworkUrl512, title: output.app.trackName)
        appItemView.configure(with: output.app)
        descLabel.text = output.app.description
    }
    
    func createSnapshotOfView() {
        let snapshotImage = view.createSnapshot()
        snapshotView.image = snapshotImage
        scrollView.addSubview(snapshotView)
        
        snapshotView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        scrollView.delegate = self
    }
}

extension TodayCardViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPositionForDismissal: CGFloat = 20.0
        var yContentOffset = scrollView.contentOffset.y
        
        if scrollView.isTracking {
            scrollView.bounces = true
        } else {
            scrollView.bounces = yContentOffset > 0
        }
        
        if yContentOffset < 0 && scrollView.isTracking {
            viewsAreHidden = true
            snapshotView.isHidden = false
            
            let scale = (100 + yContentOffset) / 100
            snapshotView.transform = CGAffineTransform(scaleX: scale, y: scale)
            snapshotView.layer.cornerRadius = -yContentOffset > yPositionForDismissal ? yPositionForDismissal : -yContentOffset
            
            if yPositionForDismissal + yContentOffset <= 0 {
                self.vm.dismissDetail()
            }
        } else {
            viewsAreHidden = false
            snapshotView.isHidden = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.bounces = true
    }
}
