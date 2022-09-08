//
//  FilterOprtionsConfigurator.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

protocol FilterOptionsConfiguratorProtocol {
    var brands: [String] { get }
    var prices: [String] { get }
    var sizes: [String] { get }
}

class FilterOptionsConfigurator: Configurator {
    
    private let data: FilterOptionsConfiguratorProtocol
    
    init(data: FilterOptionsConfiguratorProtocol) {
        self.data = data
    }
    
    func configure() -> UIViewController {
        let filterViewModel = FilterOptionsViewModel(brands: data.brands,
                                                     prices: data.prices,
                                                     sizes: data.sizes)
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
