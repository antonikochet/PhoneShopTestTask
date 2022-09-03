//
//  FilterOprtionsConfigurator.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

class FilterOptionsConfigurator: Configurator {
    
    private let brands: [String]
    private let prices: [String]
    private let sizes: [String]
    
    init(brands: [String], prices: [String], sizes: [String]) {
        self.brands = brands
        self.prices = prices
        self.sizes = sizes
    }
    
    func configure() -> UIViewController {
        let filterViewModel = FilterOptionsViewModel(brands: brands,
                                                     prices: prices,
                                                     sizes: sizes)
        let vc = FilterOptionsViewController()
        vc.viewModel = filterViewModel
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .pageSheet
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        return navVC
    }
}
