//
//  TodayViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit

final class TodayViewController: UIViewController {
    
    var vm: TodayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
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
