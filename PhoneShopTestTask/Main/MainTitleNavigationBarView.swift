//
//  MainTitleNavigationBarView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 08.09.2022.
//

import UIKit

class MainTitleNavigationBarView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "location")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "orange")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.markProFont(size: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor(white: 179/255, alpha: 1)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(locationLabel)
        addSubview(button)
        
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0))
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        locationLabel.anchor(top: topAnchor,
                             leading: imageView.trailingAnchor,
                             bottom: bottomAnchor,
                             trailing: nil,
                             padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
        
        button.anchor(top: topAnchor,
                      leading: locationLabel.trailingAnchor,
                      bottom: bottomAnchor,
                      trailing: trailingAnchor,
                      padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    func set(location: String) {
        locationLabel.text = location
    }
}
