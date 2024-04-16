//
//  SearchViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift

final class SearchViewController: UIViewController {
    
    var vm: SearchViewModel!
    private let disposeBag = DisposeBag()
    private let searchResultController = SearchResultViewController()
    
    private lazy var searchVC = UISearchController(searchResultsController: searchResultController)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?
    
    private let searchTrigger = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupSearchController()
        setupCollectionView()
        setDataSource()
        bind()
        bindView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(SearchTermCollectionViewCell.self, forCellWithReuseIdentifier: SearchTermCollectionViewCell.identifier)
        collectionView.register(SearchRecommendedAppCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecommendedAppCollectionViewCell.identifier)
        collectionView.register(SearchHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCollectionReusableView.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.placeholder = "게임, 앱, 스토리 등"
    }
    
    private func setupNavigation() {
        navigationItem.title = "검색"
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            searchText: searchVC.searchBar.rx.text.asObservable(),
            searchButtonTapped: searchVC.searchBar.rx.searchButtonClicked.asObservable(),
            searchTrigger: searchTrigger
        )
        
        let output = vm.transform(input)
        
        output.appResults.bind { [weak self] apps in
            guard let self = self,
                  let resultVC = self.searchVC.searchResultsController as? SearchResultViewController
            else { return }
            
            resultVC.apps.onNext(apps)
        }
        .disposed(by: disposeBag)
        
        output.sectionModels.subscribe(onNext: { [weak self] sectionModels in
            self?.applySnapshot(sectionModels: sectionModels)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindView() {
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .term(let term):
                self?.searchVC.rx.isActive.onNext(true)
                self?.searchVC.searchBar.rx.text.onNext(term)
                self?.searchTrigger.onNext(term)
            default:
                return
            }
        })
        .disposed(by: disposeBag)
    }
}

private extension SearchViewController {
    
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .term(let term):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTermCollectionViewCell.identifier, for: indexPath)
                        as? SearchTermCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: term)
                return cell
            case .list(let app):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecommendedAppCollectionViewCell.identifier, for: indexPath)
                        as? SearchRecommendedAppCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: app)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCollectionReusableView.identifier, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .newRecovery(let headerText):
                (header as? SearchHeaderCollectionReusableView)?.configure(title: headerText)
            case .recommendedApps(let headerText):
                (header as? SearchHeaderCollectionReusableView)?.configure(title: headerText)
            default:
                break
            }
            
            return header
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIdx, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIdx)
            
            switch section {
            case .newRecovery:
                return self?.createTermSection()
            case .recommendedApps:
                return self?.createListSection()
            default:
                return self?.createTermSection()
            }
        }
    }
    
    func createTermSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(termItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(termGroupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        
        return section
    }
    
    func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(listItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(listItemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        
        return section
    }
    
    func applySnapshot(sectionModels: [SearchSectionModel]) {
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

fileprivate let termItemHeight: CGFloat = 18
fileprivate let termGroupHeight: CGFloat = termItemHeight * 3
fileprivate let headerHeight: CGFloat = 60
fileprivate let listItemHeight: CGFloat = 110
