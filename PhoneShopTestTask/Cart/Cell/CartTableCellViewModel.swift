//
//  CartTableCellViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import Foundation

protocol CartTableCellViewModelProtocol {
    init(data: BasketCardData)
    
    var nameProduct: String { get }
    var price: String { get }
    
    var didLoadImage: ((Data?) -> Void)? { get set }
    
    func startLoadData()
}

class CartTableCellViewModel: CartTableCellViewModelProtocol {
    private var basket: BasketCardData
    
    required init(data: BasketCardData) {
        basket = data
    }
    
    var nameProduct: String {
        basket.title
    }
    
    var price: String {
        String.convertNumberInPrice(for: basket.price as NSNumber, isOutDouble: true)
    }
    
    var didLoadImage: ((Data?) -> Void)?
    
    func startLoadData() {
        NetworkManager.shared.loadImageData(basket.images) { [weak self] result in
            switch result {
            case .success(let data):
                self?.didLoadImage?(data)
            case .failure(let error):
                print("image \(self?.basket.images ?? "") not load error: \(error)")
            }
        }
    }

    
}

