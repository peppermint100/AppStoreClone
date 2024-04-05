//
//  AppItemPresentationViewController.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/1/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources

class ItunesAppDetailViewController: UIViewController {
    
    var vm: ItunesAppDetailViewModel!
    private let disposeBag = DisposeBag()
    var cellHeights = [CGFloat]()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(AppDetailHeadImageTableViewCell.self, forCellReuseIdentifier: AppDetailHeadImageTableViewCell.identifier)
        tv.register(AppDetailLaunchableTableViewCell.self, forCellReuseIdentifier: AppDetailLaunchableTableViewCell.identifier)
        tv.register(AppDetailDescTableViewCell.self, forCellReuseIdentifier: AppDetailDescTableViewCell.identifier)
        tv.register(AppDetailSummaryTableViewCell.self, forCellReuseIdentifier: AppDetailSummaryTableViewCell.identifier)
        tv.register(AppDetailScreenshotsTableViewCell.self, forCellReuseIdentifier: AppDetailScreenshotsTableViewCell.identifier)
        tv.register(AppDetailAdditionalInfoTableViewCell.self, forCellReuseIdentifier: AppDetailAdditionalInfoTableViewCell.identifier)
        return tv
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
        setupTableView()
        setupCloseButton()
        bind()
    }
}

extension ItunesAppDetailViewController {
    private func bind() {
        let input = ItunesAppDetailViewModel.Input()
        let output = vm.transform(input)
        
        output.cells
            .bind(to: tableView.rx.items) { (tableView, index, element) in
                switch element {
                case .headImage(let urlString):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailHeadImageTableViewCell.identifier)
                            as? AppDetailHeadImageTableViewCell else { return UITableViewCell() }
                    cell.configure(with: urlString)
                    return cell
                case .launchable(let iconUrlString, let title, let subtitle, let trackId):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailLaunchableTableViewCell.identifier)
                            as? AppDetailLaunchableTableViewCell else { return UITableViewCell() }
                    cell.configure(iconUrlString: iconUrlString, title: title, subtitle: subtitle, trackId: trackId)
                    return cell
                case .summary(let summaries):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailSummaryTableViewCell.identifier)
                            as? AppDetailSummaryTableViewCell else { return UITableViewCell() }
                    cell.configure(summaries: summaries)
                    return cell
                case.description(let desc):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailDescTableViewCell.identifier)
                            as? AppDetailDescTableViewCell else { return UITableViewCell() }
                    cell.configure(desc: desc)
                    cell.didTapMoreButtonClosure = {
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                    return cell
                case .screenshots(let screenshotsUrlsString):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailScreenshotsTableViewCell.identifier)
                            as? AppDetailScreenshotsTableViewCell else { return UITableViewCell() }
                    cell.configure(with: screenshotsUrlsString)
                    return cell
                case .additionalInfo(let infoList):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailAdditionalInfoTableViewCell.identifier)
                            as? AppDetailAdditionalInfoTableViewCell else { return UITableViewCell() }
                    cell.configure(with: infoList)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output.cellHeights.subscribe(onNext: { [weak self] heights in
            self?.cellHeights = heights
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
}

extension ItunesAppDetailViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
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
}

extension ItunesAppDetailViewController {
    func setTransition() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
}

extension ItunesAppDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return UITableView.automaticDimension
        }
        
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ItunesAppDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardTransitionManager(animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardTransitionManager(animationType: .dismiss)
    }
}
