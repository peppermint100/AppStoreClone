//
//  SearchViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift

class SearchViewController: UIViewController {
    
    var vm: SearchViewModel!
    private let disposeBag = DisposeBag()
    
    let searchVC = UISearchController(searchResultsController: SearchResultViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        bind()
        setupSearchController()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
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
            searchButtonTapped: searchVC.searchBar.rx.searchButtonClicked.asObservable()
        )
        
        let output = vm.transform(input)
        
        output.appResults.bind { [weak self] apps in
            guard let self = self,
                  let resultVC = self.searchVC.searchResultsController as? SearchResultViewController
            else { return }
            
            resultVC.apps.onNext(apps)
        }
        .disposed(by: disposeBag)
    }
}
