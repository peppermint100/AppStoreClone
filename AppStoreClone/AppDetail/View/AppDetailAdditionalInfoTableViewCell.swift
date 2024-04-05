//
//  AppDetailInfoTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit

class AppDetailAdditionalInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AppDetailInfoTableViewCell"
    
    var appInfo = [AdditionalInfo]()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(AdditionalInfoNameAndValueTableViewCell.self, forCellReuseIdentifier: AdditionalInfoNameAndValueTableViewCell.identifier)
        tv.register(AdditionalInfoLinkTableViewCell.self, forCellReuseIdentifier: AdditionalInfoLinkTableViewCell.identifier)
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with appInfo: [AdditionalInfo]) {
        self.appInfo = appInfo
    }
}

extension AppDetailAdditionalInfoTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoType = self.appInfo[indexPath.row]
        switch infoType {
        case .nameAndValue(let title, let value):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalInfoNameAndValueTableViewCell.identifier, for: indexPath)
                    as? AdditionalInfoNameAndValueTableViewCell
            else { return UITableViewCell() }
            cell.configure(name: title, value: value)
            return cell
        case .link(let alt, let urlString, let iconImage):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalInfoLinkTableViewCell.identifier, for: indexPath)
                    as? AdditionalInfoLinkTableViewCell
            else { return UITableViewCell() }
            cell.configure(altText: alt, linkUrlString: urlString, iconImage: iconImage)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
