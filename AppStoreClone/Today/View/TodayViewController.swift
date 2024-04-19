//
//  TodayViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit
import RxSwift

final class TodayViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var selectedBigCell: TodayBigCollectionViewCell?
    var selectedBannerCell: TodayBannerCollectionViewCell?
    
    var vm: TodayViewModel!
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<TodaySection, TodayItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setDataSource()
        bind()
        bindView()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    func setupCollectionView() {
        collectionView.delaysContentTouches = false /// 셀 터치시 바운스 애니메이션 감도를 강하게 설정하기 위함
        collectionView.register(TodayBigCollectionViewCell.self, forCellWithReuseIdentifier: TodayBigCollectionViewCell.identifier)
        collectionView.register(TodayBannerCollectionViewCell.self, forCellWithReuseIdentifier: TodayBannerCollectionViewCell.identifier)
        collectionView.register(TodayListCollectionViewCell.self, forCellWithReuseIdentifier: TodayListCollectionViewCell.identifier)
        collectionView.register(TodayHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    func bind() {
        let input = TodayViewModel.Input()
        let output = vm.transform(input)
        
        setupNavigation(output)
        
        output.todaysApp.bind { [weak self] result in
            let today = TodaySection.today
            self?.applySnapshot(items: [TodayItem.big(result)], section: today)
        }.disposed(by: disposeBag)
        
        output.deliveryApp.bind { [weak self] result in
            let banner = TodaySection.adBanner
            self?.applySnapshot(items: [TodayItem.banner(result)], section: banner)
        }.disposed(by: disposeBag)
        
        output.gameApps.bind { [weak self] result in
            let list = TodaySection.vertical("추천", "에디터도 플레이 중")
            let items = result.map { TodayItem.list($0) }
            self?.applySnapshot(items: items, section: list)
        }.disposed(by: disposeBag)
    }
    
    func bindView() {
        collectionView.rx.itemSelected.bind { [weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .big(let app):
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? TodayBigCollectionViewCell else { return }
                self?.selectedBigCell = cell
                self?.vm.didTapTransitionCell(with: .big(app))
                return
            case .banner(let app):
                let cell = self?.collectionView.cellForItem(at: indexPath) as? TodayBannerCollectionViewCell
                self?.selectedBannerCell = cell
                self?.vm.didTapNavigationCell(with: app)
                return
            case .list(let app):
                self?.vm.didTapNavigationCell(with: app)
                return
            default:
                return
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigation(_ output: TodayViewModel.Output) {
        navigationItem.title = output.navigationTitle
    }
}

private extension TodayViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIdx, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIdx)
            
            switch section {
            case .today:
                return self?.createBigSection()
            case .adBanner:
                return self?.createBannerSection()
            case .vertical:
                return self?.createListSection()
            default:
                return self?.createBigSection()
            }
        }, configuration: config)
    }
    
    func createBigSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: SizeConstant.layoutMargin, bottom: 0, trailing: SizeConstant.layoutMargin)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(SizeConstant.bigCellImageHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        
        return section
    }
}

private extension TodayViewController {
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TodaySection, TodayItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .big(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayBigCollectionViewCell.identifier, for: indexPath)
                        as? TodayBigCollectionViewCell else { return UICollectionViewCell()}
                let cardView = TodayCardView(cardType: .cell)
                cardView.configure(imageUrlString: app.artworkUrl512, title: app.trackName)
                cell.cardView = cardView
                return cell
            case .banner(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayBannerCollectionViewCell.identifier, for: indexPath)
                        as? TodayBannerCollectionViewCell else { return UICollectionViewCell()}
                cell.configure(with: app)
                return cell
            case .list(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayListCollectionViewCell.identifier, for: indexPath)
                        as? TodayListCollectionViewCell else { return UICollectionViewCell()}
                cell.configure(with: app)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .vertical(let subtitle, let title):
                (header as? TodayHeaderCollectionReusableView)?.configure(title: title, subtitle: subtitle)
            default:
                break
            }
            
            return header
        }
    }
}

private extension TodayViewController {
    func applySnapshot(items: [TodayItem], section: TodaySection) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TodayViewController {
    
    enum SizeConstant {
        static let layoutMargin: CGFloat = 20
        static let bigCellImageHeight: CGFloat = 400
        static let bigCellImageWidth: CGFloat = GlobalSizeConstant.screenWidth - layoutMargin * 2
        static let bannerCellIconWidth: CGFloat = 85
    }
}
