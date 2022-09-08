//
//  MainConfiguranor.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

class MainConfigurator: Configurator {
    func configure() -> UIViewController {
        let viewController = MainViewController()
        viewController.viewModel = MainViewModel(networkManager: NetworkManager(), dataStorage: DataStorage())
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        
        return navigationVC
    }
}
