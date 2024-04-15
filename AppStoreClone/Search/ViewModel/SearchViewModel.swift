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
    }
    
    struct Output {
        let appResults: BehaviorSubject<[ItunesApp]>
    }
    
    func transform(_ input: Input) -> Output {
        
        let appResults: BehaviorSubject<[ItunesApp]> = BehaviorSubject(value: [])
        
        input.searchButtonTapped.withLatestFrom(input.searchText) { $1 }
            .map { $0 ?? "" }
            .subscribe(onNext: { [weak self] term in
                guard term != "", let self = self else { return }
                self.getApps(by: term)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { apps in
                        appResults.onNext(apps)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        return Output(
            appResults: appResults
        )
    }
}

private extension SearchViewModel {
    
    func getApps(by term: String) -> Observable<[ItunesApp]> {
        return service.getSoftwares(.search(term: term))
    }
}
