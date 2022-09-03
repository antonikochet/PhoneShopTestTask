//
//  FilterOptionsViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 02.09.2022.
//

import Foundation

enum FilterOptions {
    case brand
    case price
    case size
}

protocol FilterOptionsViewModelProtocol {
    var title: String { get }
    
    func numberOfRows(_ filter: FilterOptions) -> Int
    func getRowValue(at index: Int, for filter: FilterOptions) -> String
    func getViewModel(for filter: FilterOptions) -> FilterOptionViewModelProtocol
    
    init(brands: [String], prices: [String], sizes: [String])
}

class FilterOptionsViewModel: FilterOptionsViewModelProtocol {
    
    private let brands: [String]
    private let prices: [String]
    private let sizes: [String]
    
    required init(brands: [String], prices: [String], sizes: [String]) {
        self.brands = brands
        self.prices = prices
        self.sizes = sizes
    }
    
    //MARK: - ViewModelProtocol
    var title: String {
        "Filter options"
    }
    
    func numberOfRows(_ filter: FilterOptions) -> Int {
        switch filter {
        case .brand:
            return brands.count
        case .price:
            return prices.count
        case .size:
            return sizes.count
        }
    }
    
    func getRowValue(at index: Int, for filter: FilterOptions) -> String {
        switch filter {
        case .brand:
            return brands[index]
        case .price:
            return prices[index]
        case .size:
            return sizes[index]
        }
    }
    
    func getViewModel(for filter: FilterOptions) -> FilterOptionViewModelProtocol {
        switch filter {
        case .brand:
            return FilterOptionViewModel(filter, firstText: brands[0])
        case .price:
            return FilterOptionViewModel(filter, firstText: prices[1])
        case .size:
            return FilterOptionViewModel(filter, firstText: sizes[0])
        }
    }
}
