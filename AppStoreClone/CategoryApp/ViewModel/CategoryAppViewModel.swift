//
//  CategoryAppViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/13/24.
//

import Foundation
import RxSwift

final class CategoryAppViewModel: Coordinating {
    
    var coordinator: Coordinator
    var service: ItunesService
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: Coordinator, service: ItunesService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let sectionModels: Observable<[CategorySectionModel]>
        let navigationTitle: String
    }
    
    func transform(_ input: Input) -> Output {
        let sectionData: Observable<[CategorySectionModel]> = input.viewDidLoadTrigger.flatMapLatest { [unowned self] _ -> Observable<[CategorySectionModel]> in
            Observable.combineLatest(
                self.service.getSoftwares(.photo),
                self.service.getSoftwares(.map),
                self.service.getSoftwares(.note),
                self.service.getSoftwares(.watch)
            ) { photoApps, mapApps, noteApps, watchApps in
                let photoData = CategorySectionModel(
                    section: CategorySection.photo(headerTitle: "사진", headerSubtitle: "에디터가 직접 고른 사진 앱"),
                    items: photoApps.map { CategoryItem.horizontalList($0) }
                )
                
                let mapData = CategorySectionModel(
                    section: CategorySection.map(headerTitle: "지도", headerSubtitle: "다양한 지도 앱들을 살펴보세요"),
                    items: mapApps.map { CategoryItem.horizontalList($0) }
                )
                
                let noteData = CategorySectionModel(
                    section: CategorySection.note(headerTitle: "노트", headerSubtitle: "지식을 저장하세요."),
                    items: noteApps.map { CategoryItem.horizontalList($0) }
                )
                
                let watchData = CategorySectionModel(
                    section: CategorySection.watch(headerTitle: "필수 Apple Watch 앱", headerSubtitle: "나를 위한 추천"),
                    items: watchApps.map { CategoryItem.gradientBackgroundList($0) }
                )
                
                return [mapData, watchData, noteData, photoData]
            }
        }
        
        return Output(
            sectionModels: sectionData,
            navigationTitle: "앱"
        )
    }
}

extension CategoryAppViewModel {
    
    func didTapCell(with app: ItunesApp) {
        guard let coordinator = coordinator as? CategoryAppCoordinator else { return }
        coordinator.navigateToAppDetail(with: app)
    }
}

extension CategoryAppViewModel {
    enum SizeConstant {
        static let segmentedControlHeight: CGFloat = 30
    }
}
