//
//  CartTableCellViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import Foundation

protocol CartTableCellViewModelProtocol {
    init(data: ProductCart, networkManager: Networking)
    
    var nameProduct: String { get }
    var price: String { get }
    var counterProduct: String { get }
    
    var didLoadImage: ((Data?) -> Void)? { get set }
    
    func startLoadData()
    func didChangedCountProduct(with operation: (Int, Int) -> Int)
}

protocol CartTableCellViewModelDelegate: AnyObject {
    func didChangeCountProduct(_ productId: Int, newCount: Int)
}

class CartTableCellViewModel: CartTableCellViewModelProtocol {
    weak var delegate: CartTableCellViewModelDelegate?
    
    private let networkManager: Networking
    private var product: ProductCart
    
    required init(data: ProductCart, networkManager: Networking) {
        self.networkManager = networkManager
        product = data
    }
    
    var nameProduct: String {
        product.name
    }
    
    var price: String {
        String.convertNumberInPrice(for: product.price * product.count as NSNumber, isOutDouble: true)
    }
    
    var counterProduct: String {
        String(product.count)
    }
    
    var didLoadImage: ((Data?) -> Void)?
    
    func didChangedCountProduct(with operation: (Int, Int) -> Int) {
        let newCount = operation(product.count, 1)
        if newCount >= 0 {
            delegate?.didChangeCountProduct(product.id, newCount: newCount)
            product.count = newCount
        }
    }
    
    func startLoadData() {
        networkManager.loadImageData(product.image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.didLoadImage?(data)
            case .failure(let error):
                print("image \(self.product.image) not load error: \(error)")
            }
        }
    }

    
}

