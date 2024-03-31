//
//  TodayViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit

final class TodayViewController: UIViewController {
    
    var vm: TodayViewModel!
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<TodaySection, TodayItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setDataSource()
        setSnapshot()
        bind()
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
        collectionView.register(TodayBigCollectionViewCell.self, forCellWithReuseIdentifier: TodayBigCollectionViewCell.identifier)
        collectionView.register(TodayBannerCollectionViewCell.self, forCellWithReuseIdentifier: TodayBannerCollectionViewCell.identifier)
        collectionView.register(TodayListCollectionViewCell.self, forCellWithReuseIdentifier: TodayListCollectionViewCell.identifier)
        collectionView.register(TodayHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    func bind() {
        let input = TodayViewModel.Input()
        let output = vm.transform(input)
        setupNavigationBar(output)
    }
    
    func setupNavigationBar(_ output: TodayViewModel.Output) {
        let titleView = TodayNavigationTitleView()
        titleView.backgroundColor = .red
        titleView.configure(title: output.navigationTitle, subtitle: output.todayMonthAndDate)
        navigationItem.titleView = titleView
    }
}

private extension TodayViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] section, _ in
            switch section {
            case 0:
                self?.createBigSection()
            case 1:
                self?.createBannerSection()
            case 2:
                self?.createListSection()
            default:
                self?.createBigSection()
            }
        }, configuration: config)
        
        return layout
    }
    
    func createBigSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500))
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
                cell.configure(with: app)
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
    
    func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TodaySection, TodayItem>()
        let apps = try! StaticJSONMapper.decode(file: "apps", type: ItunesResponse.self)
        let bigItems = apps.results.map { TodayItem.big($0) }.first!
        let bannerItems = apps.results.map { TodayItem.banner($0) }.first!
        let listItems = apps.results.map { TodayItem.list($0) }
        
        let today = TodaySection.today
        snapshot.appendSections([today])
        snapshot.appendItems([bigItems], toSection: today)
        
        let adBanner = TodaySection.adBanner
        snapshot.appendSections([adBanner])
        snapshot.appendItems([bannerItems], toSection: adBanner)
        
        let vertical = TodaySection.vertical("추천", "에디터도 플레이 중")
        snapshot.appendSections([vertical])
        snapshot.appendItems(listItems, toSection: vertical)
        
        dataSource?.apply(snapshot)
    }
}
