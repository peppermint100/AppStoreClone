//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import Foundation
import RxSwift

final class SearchViewModel: Coordinating {
    var coordinator: Coordinator
    private let service: ItunesService
    private let disposeBag = DisposeBag()
    
    init(coordinator: Coordinator, service: ItunesService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    struct Input {
        let searchText: Observable<String?>
        let searchButtonTapped: Observable<Void>
        let searchTrigger: Observable<String>
    }
    
    struct Output {
        let appResults: BehaviorSubject<[ItunesApp]>
        let sectionModels: Observable<[SearchSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let appResults: BehaviorSubject<[ItunesApp]> = BehaviorSubject(value: [])
        let newRecoveryKeywords = Observable.just(["vpn", "blue link", "pass앱", "다이어트", "유투브음악", "for instagram"])
        let recommendedApps = service.getSoftwares(.search(term: "추천"))
        
        input.searchTrigger.subscribe(onNext: { [weak self] term in
            guard term != "", let self = self else { return }
            self.search(by: term, results: appResults)
        })
        .disposed(by: disposeBag)
        
        input.searchButtonTapped.withLatestFrom(input.searchText) { $1 }
            .map { $0 != nil && !$0!.isEmpty ? $0! : "" }
            .subscribe(onNext: { [weak self] term in
                guard term != "", let self = self else { return }
                self.search(by: term, results: appResults)
            })
            .disposed(by: self.disposeBag)
        
        let sectionModels = Observable.combineLatest(newRecoveryKeywords, recommendedApps) { newRecoveryKeywords, recommendedApps in
            let newRecoveryModel = SearchSectionModel(
                section: .newRecovery(headerText: "새로운 발견"),
                items: newRecoveryKeywords.map { SearchItem.term($0) })
            
            let recommendedAppsModel = SearchSectionModel(
                section: .recommendedApps(headerText: "추천 앱과 게임"),
                items: recommendedApps.map { SearchItem.list($0) })
            
            return [newRecoveryModel, recommendedAppsModel]
        }
        
        return Output(
            appResults: appResults,
            sectionModels: sectionModels
        )
    }
        
    func openDetail(with app: ItunesApp) {
        guard let coordinator = coordinator as? SearchCoordinator else { return }
        coordinator.navigateToDetail(app: app)
    }
}

private extension SearchViewModel {
    
    func getApps(by term: String) -> Observable<[ItunesApp]> {
        return service.getSoftwares(.search(term: term))
    }
    
    func search(by term: String, results: BehaviorSubject<[ItunesApp]>) {
        self.getApps(by: term)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { apps in
                results.onNext(apps)
            })
            .disposed(by: self.disposeBag)
    }
}
