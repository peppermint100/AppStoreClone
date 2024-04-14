//
//  AppViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/13/24.
//

import UIKit
import SnapKit
import RxSwift

class CategoryAppViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var vm: CategoryAppViewModel!
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<CategorySection, CategoryItem>?
    private let viewDidLoadTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setDataSource()
        bind()
        bindView()
        viewDidLoadTrigger.onNext(())
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(CategoryAppItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryAppItemCollectionViewCell.identifier)
        collectionView.register(CategoryAppItemGradientCollectionViewCell.self, forCellWithReuseIdentifier: CategoryAppItemGradientCollectionViewCell.identifier)
        collectionView.register(CategoryAppHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryAppHeaderCollectionReusableView.identifier)
        collectionView.register(GradientHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GradientHeaderCollectionReusableView.identifier)
    }
    
    private func bind() {
        let input = CategoryAppViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger
        )
        let output = vm.transform(input)
        
        output.sectionModels
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] sectionModels in
                self?.applySnapshot(sectionModels: sectionModels)
            })
            .disposed(by: disposeBag)
        
        navigationItem.title = output.navigationTitle
    }
    
    private func bindView() {
        collectionView.rx.itemSelected.bind { [weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .horizontalList(let app):
                self?.vm.didTapCell(with: app)
                return
            case .gradientBackgroundList(let app):
                self?.vm.didTapCell(with: app)
                return
            default:
                return
            }
        }
        .disposed(by: disposeBag)
    }
}

private extension CategoryAppViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIdx, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIdx)
            
            switch section {
            case .photo:
                return self?.createHorizontalListSection()
            case .map:
                return self?.createHorizontalListSection()
            case .note:
                return self?.createHorizontalListSection()
            case .watch:
                return self?.createGradientSection()
            default:
                return self?.createHorizontalListSection()
            }
        }
        
        layout.register(BackgroundCollectionReusableView.self, forDecorationViewOfKind: BackgroundCollectionReusableView.identifier)
        
        return layout
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .horizontalList(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryAppItemCollectionViewCell.identifier, for: indexPath)
                        as? CategoryAppItemCollectionViewCell else { return UICollectionViewCell()}
                cell.configure(with: app)
                return cell
           case .gradientBackgroundList(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryAppItemGradientCollectionViewCell.identifier, for: indexPath)
                        as? CategoryAppItemGradientCollectionViewCell else { return UICollectionViewCell()}
                cell.configure(with: app)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .photo(let title, let subtitle):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryAppHeaderCollectionReusableView.identifier, for: indexPath)
                (header as? CategoryAppHeaderCollectionReusableView)?.configure(title: title, subtitle: subtitle)
                return header
            case .map(let title, let subtitle):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryAppHeaderCollectionReusableView.identifier, for: indexPath)
                (header as? CategoryAppHeaderCollectionReusableView)?.configure(title: title, subtitle: subtitle)
                return header
            case .note(let title, let subtitle):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryAppHeaderCollectionReusableView.identifier, for: indexPath)
                (header as? CategoryAppHeaderCollectionReusableView)?.configure(title: title, subtitle: subtitle)
                return header
            case .watch(let title, let subtitle):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GradientHeaderCollectionReusableView.identifier, for: indexPath)
                (header as? GradientHeaderCollectionReusableView)?.configure(title: title, subtitle: subtitle)
                return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GradientHeaderCollectionReusableView.identifier, for: indexPath)
                (header as? GradientHeaderCollectionReusableView)?.configure(title: "", subtitle: "")
                return header
            }
        }
    }
    
    private func createHorizontalListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(appItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(appItemHeight * 3 - 30 + 70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createGradientSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(gradientAppItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(gradientAppItemHeight * 2 - 15 + gradientHeaderHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundCollectionReusableView.identifier)
        section.decorationItems = [backgroundDecoration]
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(gradientHeaderHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    func applySnapshot(sectionModels: [CategorySectionModel]) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        for sectionModel in sectionModels {
            let section = sectionModel.section
            if !snapshot.sectionIdentifiers.contains(section) {
                snapshot.appendSections([section])
            }
            snapshot.appendItems(sectionModel.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

fileprivate let appItemHeight: CGFloat = 100
fileprivate let gradientAppItemHeight: CGFloat = 120
fileprivate let gradientHeaderHeight: CGFloat = 120
