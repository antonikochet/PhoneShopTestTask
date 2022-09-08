//
//  DetailsConfigurator.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

class DetailsConfigurator: Configurator {
    private let idDevice: Int?
    private let product: ProductCart?
    
    init(id: Int) {
        self.idDevice = id
        self.product = nil
    }
    
    init(product: ProductCart) {
        self.product = product
        self.idDevice = nil
    }
    
    func configure() -> UIViewController {
        let vc = DetailsViewController()
        var viewModel: DetailsViewModelProtocol?
        if let id = idDevice {
            viewModel = DetailsViewModel(id, networkManager: NetworkManager(), dataStorage: DataStorage())
        } else if let product = product {
            viewModel = DetailsViewModel(product, networkManager: NetworkManager(), dataStorage: DataStorage())
        }
        vc.viewModel = viewModel
        return vc
    }
}
