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

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = SearchViewModel.Input()
        let output = vm.transform(input)
        
        navigationItem.title = output.navigationTitle
    }
}
