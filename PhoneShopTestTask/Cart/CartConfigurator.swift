//
//  CartConfigurator.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import UIKit

class CartConfigurator: Configurator {
    func configure() -> UIViewController {
        let vc = CartViewController()
        let viewModel = CartViewModel()
        vc.viewModel = viewModel
        
        return vc
    }
    
    
}
