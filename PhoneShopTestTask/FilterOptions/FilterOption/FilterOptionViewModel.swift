//
//  FilterOptionViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import Foundation

protocol FilterOptionViewModelProtocol {
    var name: String { get }
    var text: String { get }
    
    var didChangeViewModel: ((FilterOptionViewModelProtocol) -> Void)? { get set }
    func didChangeText(_ text: String)
    init(_ brand: FilterOptions, firstText: String)
}

class FilterOptionViewModel: FilterOptionViewModelProtocol {
    private let brand: FilterOptions
    private var textInMoment: String
    
    required init(_ brand: FilterOptions, firstText: String) {
        self.brand = brand
        self.textInMoment = firstText
    }
    
    var name: String {
        switch brand {
        case .brand:
            return "Brand"
        case .price:
            return "Price"
        case .size:
            return "Size"
        }
    }
    
    var text: String {
        textInMoment
    }

    var didChangeViewModel: ((FilterOptionViewModelProtocol) -> Void)?
    
    func didChangeText(_ text: String) {
        textInMoment = text
        didChangeViewModel?(self)
    }
}
