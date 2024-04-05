//
//  AppdetailScreenshotsTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class AppDetailScreenshotsTableViewCell: UITableViewCell {
    
    static let identifier = "AppdetailScreenshotsTableViewCell"
    private var screenshotsUrlString = [String]()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(AppDetailScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailScreenshotCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        return layout
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with screenshotsUrlString: [String]) {
        self.screenshotsUrlString = screenshotsUrlString
    }
}

extension AppDetailScreenshotsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailScreenshotCollectionViewCell.identifier, for: indexPath)
                as? AppDetailScreenshotCollectionViewCell else { return UICollectionViewCell() }
        let screenshotUrlString = self.screenshotsUrlString[indexPath.row]
        cell.configure(with: screenshotUrlString)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshotsUrlString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width / 1.5 - 20
        let itemHeight: CGFloat = collectionView.frame.height - 50
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout
        let itemWidth = UIScreen.main.bounds.width / 1.5 - 20
        
        let cellWidthIncludingSpacing = itemWidth + 20
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                         y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
