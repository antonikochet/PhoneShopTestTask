//
//  CategoryTableViewCell.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import UIKit

protocol CategoryTableCellViewModelProtocol: MainViewModelProtocol {
    var indexSelectedItem: Int { get }
    var numberCategories: Int { get }
    func didSelectedItem(at index: Int)
    func getViewModel(at index: Int) -> CategoryCollectionCellViewModelProcorol
}

class CategoryTableViewCell: UITableViewCell {

    static let identifier = "CategoryTableViewCell"
    
    var viewModel: CategoryTableCellViewModelProtocol!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTextField.delegate = self
        
        collectionView.anchor(top: contentView.topAnchor,
                                        leading: contentView.leadingAnchor,
                                        bottom: nil,
                                        trailing: contentView.trailingAnchor,
                                        padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        
        setupSearchTextField()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = .clear()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
    }
    
    private func setupSearchTextField() {
        contentView.addSubview(searchTextField)
        searchTextField.anchor(top: collectionView.bottomAnchor,
                               leading: contentView.leadingAnchor,
                               bottom: contentView.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               padding: UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 16))
        
        let height = 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height * 2, height: height))
        let image = UIImage(systemName: "magnifyingglass")
        let imageview = UIImageView(image: image)
        view.addSubview(imageview)
        imageview.center = view.center
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = UIColor(named: "orange")
        searchTextField.leftView = view
        searchTextField.leftViewMode = .always
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.viewModel = viewModel.getViewModel(at: indexPath.row)
        return cell
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: IndexPath(row: viewModel.indexSelectedItem, section: 0)) as! CategoryCollectionViewCell
        selectedCell.viewModel.didSelectedCell()
        
        viewModel.didSelectedItem(at: indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        cell.viewModel.didSelectedCell()
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 23
    }
}

extension CategoryTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
