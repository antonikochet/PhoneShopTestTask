//
//  CategoryCollectionCellViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 01.09.2022.
//

import Foundation

protocol CategoryCollectionCellViewModelProcorol: AnyObject {
    var nameCategory: String { get }
    var nameIconCategory: String { get }
    var isSelectCell: Bool { get }
    
    init(_ product: CategoryProduct, isSelect: Bool)
    func didSelectedCell()
    var changedViewModel: ((CategoryCollectionCellViewModelProcorol) -> Void)? { get set }
}

class CategoryCollectionCellViewModel: CategoryCollectionCellViewModelProcorol {
    private let product: CategoryProduct
    private var isSelect: Bool
    
    required init(_ product: CategoryProduct, isSelect: Bool) {
        self.product = product
        self.isSelect = isSelect
    }
    
    var nameCategory: String {
        product.rawValue
    }
    
    var nameIconCategory: String {
        product.nameImage
    }
    
    var isSelectCell: Bool {
        isSelect
    }
    
    func didSelectedCell() {
        isSelect.toggle()
        changedViewModel?(self)
    }
    
    var changedViewModel: ((CategoryCollectionCellViewModelProcorol) -> Void)?
}
