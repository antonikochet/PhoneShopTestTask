//
//  BestSellerTableViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 31.08.2022.
//

import UIKit

protocol BestSellerTableViewCellDelegate: AnyObject {
    func showDetailsView(at index: Int)
}

protocol BestSellerTableCellViewModelProtorol: MainViewModelProtocol {
    var numberOfRowsBestSeller: Int { get }
    
    func getBestSellerViewModel(at index: Int) -> BestSellerCollectionCellViewModelProtocol
    
    var didLoadDataForBestSeller: ((Bool) -> Void)? { get set }
}

class BestSellerTableViewCell: UITableViewCell {
    static let identifier = "BestSellerTableViewCell"
    
    private var items: [BestSellerModel] = []
    
    var viewModel: BestSellerTableCellViewModelProtorol! {
        didSet {
            viewModel.didLoadDataForBestSeller = { [weak self] result in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    if result {
                        strongSelf.errorLabel.isHidden = true
                        strongSelf.collectionView.isHidden = false
                        strongSelf.collectionView.reloadData()
                    } else {
                        strongSelf.errorLabel.isHidden = false
                        strongSelf.collectionView.isHidden = true
                        strongSelf.errorLabel.text = "Error"
                    }
                }
            }
        }
    }
    
    weak var delegate: BestSellerTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.isScrollEnabled = false
        collView.register(BestSellerCollectionViewCell.self, forCellWithReuseIdentifier: BestSellerCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.markProFont(size: 25, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        contentView.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.fillSuperview(padding: SizesCell.paddingCollectionView)
        errorLabel.fillSuperview()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = .clear()
    }
}

extension BestSellerTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsBestSeller
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCollectionViewCell.identifier, for: indexPath) as! BestSellerCollectionViewCell
        cell.viewModel = viewModel.getBestSellerViewModel(at: indexPath.row)
        return cell
    }
}

extension BestSellerTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetailsView(at: indexPath.row)
    }
}

extension BestSellerTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        SizesCell.calculateSizeCollectionCell(width: collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SizesCell.minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SizesCell.minimumLineSpacing
    }
}

extension BestSellerTableViewCell {
    struct SizesCell {
        static fileprivate let countCellInLine: Int = 2
        static fileprivate let minimumInteritemSpacing: CGFloat = 16
        static fileprivate let minimumLineSpacing: CGFloat = 16
        static fileprivate let paddingCollectionView = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)

        static fileprivate func calculateSizeCollectionCell(width: CGFloat) -> CGSize {
            let widthCell = width / CGFloat(countCellInLine) - 8
            return CGSize(width: widthCell,
                          height: widthCell * 1.2)
        }

        static internal func calculateHeightTableCell(countItem: Int, widthTable: CGFloat) -> CGFloat{
            let countLine = countItem / countCellInLine
            var height = paddingCollectionView.top +
                         paddingCollectionView.bottom
            let widthCollectionView = widthTable -
                                      paddingCollectionView.left -
                                      paddingCollectionView.right
            
            let sizeCell = calculateSizeCollectionCell(width: widthCollectionView)
            
            height = height + CGFloat(countLine) * (sizeCell.height + minimumLineSpacing)
            return height
        }
    }
}
