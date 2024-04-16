//
//  SearchResultViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift

class SearchResultViewController: UIViewController {
    
    var apps = PublishSubject<[ItunesApp]>()
    private let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.rowHeight = SearchResultTableViewCell.cellHeight
        tableView.separatorStyle = .none
    }
    
    private func bindView() {
        apps.bind(to: tableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { [weak self]
            _, app, cell in
            cell.configure(with: app)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
