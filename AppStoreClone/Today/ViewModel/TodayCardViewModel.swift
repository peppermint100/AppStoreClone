//
//  TodayCardViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/12/24.
//

import Foundation
import RxSwift

final class TodayCardViewModel: Coordinating {
    var coordinator: Coordinator
    var app: ItunesApp
    var item: TodayItem
    
    let disposeBag = DisposeBag()
    
    init(coordinator: Coordinator, app: ItunesApp, item: TodayItem) {
        self.coordinator = coordinator
        self.app = app
        self.item = item
    }
    
    struct Input {
        let closeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let app: ItunesApp
    }
    
    func transform(_ input: TodayCardViewModel.Input) -> TodayCardViewModel.Output {
        
        input.closeButtonTapped.subscribe(onNext: { _ in
            self.dismissDetail()
        })
        .disposed(by: disposeBag)
        
        return TodayCardViewModel.Output(
            app: self.app
        )
    }
    
    func dismissDetail() {
        guard let coordinator = self.coordinator as? TodayCardCoordinator else { return }
        coordinator.dismiss()
    }
}

extension TodayCardViewModel {
    enum SizeConstant {
        static let imageViewHeight: CGFloat = 400
        static let appItemViewHeight: CGFloat = 120
    }
}
