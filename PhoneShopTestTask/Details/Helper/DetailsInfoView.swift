//
//  DetailsInfoView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 04.09.2022.
//

import UIKit

enum DetailsInfoDevice:Int, CaseIterable {
    case CPU
    case camera
    case ssd
    case sd
    
    var nameImage: String {
        switch self {
        case .CPU:
            return "cpu"
        case .camera:
            return "camera"
        case .ssd:
            return "ssd"
        case .sd:
            return "sd"
        }
    }
}

class DetailsInfoView: UIView {
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(white: 183/255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 183/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(view)
        addSubview(imageView)
        addSubview(label)
        
        
        view.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: trailingAnchor)
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)])
        
        label.anchor(top: view.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor)
    }
    
    func set(_ type: DetailsInfoDevice, text: String) {
        let image = UIImage(named: type.nameImage)
        imageView.image = image
        
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
