//
//  MainHeaderView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 28.08.2022.
//

import UIKit

class MainHeaderView: UITableViewHeaderFooterView {

    static let identifier = "MainHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.markProFont(size: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "orange"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(seeMoreButton)
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: nil,
                          padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right:0))
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        seeMoreButton.anchor(top: topAnchor,
                             leading: titleLabel.trailingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
    }
    
    func set(title: String, textButton: String) {
        titleLabel.text = title
        seeMoreButton.setTitle(textButton, for: .normal)
    }
}
