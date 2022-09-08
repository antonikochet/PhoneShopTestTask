//
//  CartTableViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    static let identifier = "CartTableViewCell"
    
    var viewModel: CartTableCellViewModelProtocol! {
        didSet {
            viewModel.didLoadImage = { [weak self] data in
                if let data = data,
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.productImageView.image = image
                    }
                }
            }
            viewModel.startLoadData()
            setSubviews()
        }
    }
    
    private let productImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()

    private let nameProductLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "orange")
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 54/255, green: 54/255, blue: 77/255, alpha: 1.0)
        button.setImage(UIImage(named: "basket"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let counterView: CounterView = {
        let view = CounterView("1")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        counterView.layer.cornerRadius = counterView.frame.width / 2
        counterView.clipsToBounds = true
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = .clear()
    }
    
    private func setupSubviews() {
        contentView.addSubview(productImageView)
        productImageView.anchor(top: contentView.topAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: contentView.bottomAnchor,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0))
        productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor).isActive = true
        
        contentView.addSubview(nameProductLabel)
        nameProductLabel.anchor(top: contentView.topAnchor,
                                leading: productImageView.trailingAnchor,
                                bottom: contentView.centerYAnchor,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 2, left: 16, bottom: 0, right: 0))
        nameProductLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45).isActive = true
        
        contentView.addSubview(priceLabel)
        priceLabel.anchor(top: nameProductLabel.bottomAnchor,
                          leading: nameProductLabel.leadingAnchor,
                          bottom: contentView.bottomAnchor,
                          trailing: nil,
                          padding: UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0),
                          size: CGSize(width: 100, height: 0))
        
        contentView.addSubview(basketButton)
        basketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(counterView)
        counterView.anchor(top: contentView.topAnchor,
                         leading: nil,
                         bottom: contentView.bottomAnchor,
                         trailing: basketButton.leadingAnchor,
                         padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 24),
                         size: CGSize(width: 26, height: 0))
        counterView.addTargerButton(target: self,
                                    plusSelector: #selector(didTouchPlusButtonCounterView),
                                    minusSelector: #selector(didTouchMinusButtonCounterView))
    }
    
    private func setSubviews() {
        nameProductLabel.text = viewModel.nameProduct
        priceLabel.text = viewModel.price
        counterView.counter = viewModel.counterProduct
    }
    
    @objc private func didTouchPlusButtonCounterView() {
        viewModel.didChangedCountProduct(with: +)
        setSubviews()
    }
    
    @objc private func didTouchMinusButtonCounterView() {
        viewModel.didChangedCountProduct(with: -)
        setSubviews()
    }
}
