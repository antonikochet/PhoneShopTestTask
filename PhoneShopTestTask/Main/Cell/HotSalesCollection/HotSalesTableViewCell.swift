//
//  HotSalesTableViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 29.08.2022.
//

import UIKit

protocol HotSalesTableCellViewModelProtorol: MainViewModelProtocol {
    var numberOfRowsHotSales: Int { get }
    
    func getHotSalesViewModel(at index: Int) -> HotSalesCollectionCellViewModelProtocol
    
    var didLoadDataForHotSales: ((Bool) -> Void)? { get set }
}

class HotSalesTableViewCell: UITableViewCell {

    static let identifier = "HotSalesTableViewCell"
    
    var viewModel: HotSalesTableCellViewModelProtorol! {
        didSet {
            viewModel.didLoadDataForHotSales = { [weak self] result in
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(HotSalesCollectionViewCell.self, forCellWithReuseIdentifier: HotSalesCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
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
        
        collectionView.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        errorLabel.fillSuperview()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = .clear()
    }
}

extension HotSalesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsHotSales
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSalesCollectionViewCell.identifier, for: indexPath) as! HotSalesCollectionViewCell
        cell.viewModel = viewModel.getHotSalesViewModel(at: indexPath.row)
        return cell
    }
}

extension HotSalesTableViewCell: UICollectionViewDelegate {

}

extension HotSalesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 8,
                      height: collectionView.frame.height)
    }
}
