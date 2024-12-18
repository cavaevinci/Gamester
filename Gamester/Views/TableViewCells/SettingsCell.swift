//
//  SettingsCell.swift
//  Gamester
//
//  Created by Ivan Evačić on 16.12.2024..
//

import UIKit
import SnapKit

class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"

    private lazy var settingName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    public func configure(with setting: String) {
        settingName.text = setting
    }
    
    private func setupUI() {
        contentView.addSubview(settingName)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        settingName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.settingName.text = nil
    }
}
