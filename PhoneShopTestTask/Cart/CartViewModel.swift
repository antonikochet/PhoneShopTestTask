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
    
    var updateViews: ((CartViewModelProtocol) -> Void)? { get set }
    var didLoadData: ((CartViewModelProtocol) -> Void)? { get set }
    
    func didLoadView()
    func getCartCellViewModel(at index: Int) -> CartTableCellViewModelProtocol?
}

class CartViewModel: CartViewModelProtocol {
    static var isLoadDataForViewInStartApp = false
    
    private var cardData: CardData?
    private var products: [ProductCart] {
        didSet {
            dataStorage.setProductsCart(products)
        }
    }
    
    private var networkManager: Networking
    private var dataStorage: DataStorageProtocol
    
    init(networkManager: Networking, dataStorage: DataStorageProtocol) {
        self.networkManager = networkManager
        self.dataStorage = dataStorage
        self.products = []
    }
    
    //MARK: protocol properties
    var total: String {
        let total: Int
        if cardData != nil && products.isEmpty  {
            total = cardData!.total
        } else if products.isEmpty {
            total = 0
        } else {
            total = products.reduce(0, { $0 + $1.price * $1.count })
        }
        return "\(String.convertNumberInPrice(for: total as NSNumber)) us"
    }
    
    var delivety: String {
        cardData?.delivery ?? "Free"
    }
    
    var numberOfBasket: Int {
        products.count
    }
    
    //MARK: protocol callbacks
    var updateViews: ((CartViewModelProtocol) -> Void)?
    var didLoadData: ((CartViewModelProtocol) -> Void)?
    
    //MARK: protocol methods
    func getCartCellViewModel(at index: Int) -> CartTableCellViewModelProtocol? {
        guard index < products.count else { return nil }
        let product = products[index]
        let cellViewModel = CartTableCellViewModel(data: product, networkManager: networkManager)
        cellViewModel.delegate = self
        return cellViewModel
    }
    
    func didLoadView() {
        if !Self.isLoadDataForViewInStartApp {
            loadData()
        } else {
            products = dataStorage.getProductsCart()
            updateViews?(self)
        }
    }
    //MARK: private methods
    private func loadData() {
        networkManager.getCardScreenData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.cardData = data
                self.products = data.basket.map { ProductCart(basketData: $0) }
                Self.isLoadDataForViewInStartApp = true
                self.didLoadData?(self)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CartViewModel: CartTableCellViewModelDelegate {
    func didChangeCountProduct(_ productId: Int, newCount: Int) {
        guard let index = products.firstIndex(where: { $0.id == productId }) else { return }
        var product = products[index]
        product.count = newCount
        products[index] = product
        updateViews?(self)
    }
}
