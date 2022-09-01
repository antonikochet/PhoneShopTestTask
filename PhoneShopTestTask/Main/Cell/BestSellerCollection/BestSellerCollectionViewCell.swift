//
//  BestSellerCollectionViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 31.08.2022.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {
    static let identifier = "BestSellerCollectionViewCell"
    
    var viewModel: BestSellerCollectionCellViewModelProtocol! {
        didSet {
            viewModel.changedViewModel = { [weak self] viewModel in
                self?.drawLikeButton()
            }
            
            viewModel.viewImageData = { [weak self] data in
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
            
            viewModel.loadImageData()
            discountPriceLabel.text = viewModel.discountPrice
            priceLabel.attributedText = viewModel.price.strikeThrough()
            titleLabel.text = viewModel.title
            drawLikeButton()
            
            
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "orange")
        button.clipsToBounds = true
        button.backgroundColor = .white
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
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(discountPriceLabel)
        addSubview(priceLabel)
        addSubview(titleLabel)
        addSubview(likeView)
        likeView.addSubview(likeButton)

        
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: trailingAnchor)
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        
        discountPriceLabel.anchor(top: imageView.bottomAnchor,
                                  leading: leadingAnchor,
                                  bottom: nil,
                                  trailing: nil,
                                  padding: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0),
                                  size: CGSize(width: frame.width / 2 - 32, height: frame.height * 0.15))
        priceLabel.anchor(top: nil,
                          leading: discountPriceLabel.trailingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        priceLabel.centerYAnchor.constraint(equalTo: discountPriceLabel.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: discountPriceLabel.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        likeButton.anchor(top: imageView.topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: imageView.trailingAnchor,
                          padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 20),
                          size: CGSize(width: 25, height: 25))
        
        likeButton.fillSuperview()
        
        
        likeButton.addTarget(self, action: #selector(touchLikeButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 12
        
        let cornerRadius: CGFloat = 4
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeView.layer.shadowColor = UIColor.black.cgColor
        likeView.layer.shadowRadius = cornerRadius
        likeView.layer.shadowOpacity = 0.3
        likeView.layer.shadowOffset = CGSize(width: 1, height: 1)
        let cgPath = UIBezierPath(roundedRect: likeView.bounds,
                                  byRoundingCorners: [.allCorners],
                                  cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        likeView.layer.shadowPath = cgPath
    }
    
    func set(image: String, discountPrice: String, price: String, title: String, isLike: Bool) {
        NetworkManager.shared.loadImageData(image) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(_):
                print("error load image: \(image)")
            }
        }
    }
    
    private func drawLikeButton() {
        likeButton.setImage(viewModel.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    @objc private func touchLikeButton() {
        viewModel.didTouchFavorites()
    }
}

extension String {
    fileprivate func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
