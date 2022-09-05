//
//  DetailsConfigurator.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

class DetailsConfigurator: Configurator {
    private let idDevice: Int
    
    init(id: Int) {
        self.idDevice = id
    }
    func configure() -> UIViewController {
        let vc = DetailsViewController()
        let viewModel = DetailsViewModel(idDevice)
        vc.viewModel = viewModel
        return vc
    }
}
