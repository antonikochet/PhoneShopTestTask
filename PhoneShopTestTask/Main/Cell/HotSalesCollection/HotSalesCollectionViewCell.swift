//
//  HotSalesCollectionViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 29.08.2022.
//

import UIKit

class HotSalesCollectionViewCell: UICollectionViewCell {
    static let identifier = "HotSalesCollectionViewCell"
    
    var viewModel: HotSalesCollectionCellViewModelProtocol! {
        didSet {
            viewModel.viewImageData = { [weak self] data in
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
            viewModel.loadImageData()
            newLabel.isHidden = !viewModel.isNew
            buyButton.isHidden = !viewModel.isBuy
            brandLabel.text = viewModel.brand
            descriptionLabel.text = viewModel.desctiption
        }
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newLabel: UILabel = {
        let label = UILabel()
        label.text = "New"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.minimumScaleFactor = 0.5
        label.backgroundColor = UIColor(named: "orange")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buy now!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .none
        
        addSubview(backView)
        
        backView.addSubview(imageView)
        backView.addSubview(newLabel)
        backView.addSubview(brandLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(buyButton)
                
        backView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        newLabel.anchor(top: backView.topAnchor,
                        leading: backView.leadingAnchor,
                        bottom: nil,
                        trailing: nil,
                        padding: UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 0),
                        size: CGSize(width: 25, height: 25))
        
        brandLabel.anchor(top: newLabel.bottomAnchor,
                          leading: backView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 0))
        brandLabel.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.5).isActive = true
        
        descriptionLabel.anchor(top: brandLabel.bottomAnchor,
                                leading: backView.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        
        buyButton.anchor(top: nil,
                         leading: backView.leadingAnchor,
                         bottom: backView.bottomAnchor,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 0),
                         size: CGSize(width: 98, height: 23))
        imageView.anchor(top: backView.topAnchor,
                         leading: brandLabel.trailingAnchor,
                         bottom: backView.bottomAnchor,
                         trailing: backView.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: -frame.width * 0.25, bottom: 0, right: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.layer.cornerRadius = 12
        buyButton.layer.cornerRadius = 6
        newLabel.layer.masksToBounds = true
        newLabel.clipsToBounds = true
        newLabel.layer.cornerRadius = newLabel.frame.height / 2
    }
}
