//
//  CartViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import Foundation

protocol CartViewModelProtocol {
    var total: String { get }
    var delivety: String { get }
    var numberOfBasket: Int { get }
    
    var didLoadData: ((CartViewModelProtocol) -> Void)? { get set }
    
    func getCartCellViewModel(at index: Int) -> CartTableCellViewModelProtocol?
}

class CartViewModel: CartViewModelProtocol {
    private var cardData: CardData?
    private var networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
        loadData()
    }
    
    //MARK: protocol properties
    var total: String {
        cardData?.total != nil ? "\(String.convertNumberInPrice(for: cardData!.total as NSNumber)) us" : ""
    }
    
    var delivety: String {
        cardData?.delivery ?? ""
    }
    
    var numberOfBasket: Int {
        cardData?.basket.count ?? 0
    }
    
    //MARK: protocol callbacks
    var didLoadData: ((CartViewModelProtocol) -> Void)?
    
    //MARK: protocol methods
    func getCartCellViewModel(at index: Int) -> CartTableCellViewModelProtocol? {
        guard let basket = cardData?.basket[index] else { return nil }
        return CartTableCellViewModel(data: basket, networkManager: networkManager)
    }
    
    //MARK: private methods
    private func loadData() {
        networkManager.getCardScreenData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.cardData = data
                self.didLoadData?(self)
            case .failure(let error):
                print(error)
            }
        }
    }
}
