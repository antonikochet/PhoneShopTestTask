//
//  BestSellerCollectionCellViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 01.09.2022.
//

import Foundation

protocol BestSellerCollectionCellViewModelProtocol {
    var price: String { get }
    var discountPrice: String { get }
    var title: String { get }
    var isFavorite: Bool { get }
    
    init(_ bestSeller: BestSellerModel, networkManager: Networking)
    
    func didTouchFavorites()
    func loadImageData()
    var changedViewModel: ((BestSellerCollectionCellViewModelProtocol) -> Void)? { get set }
    var viewImageData: ((Data)->Void)? { get set }
}

class BestSellerCollectionCellViewModel: BestSellerCollectionCellViewModelProtocol {
    private let model: BestSellerModel
    private var isFavorites: Bool
    private let networkManager: Networking
    
    required init(_ bestSeller: BestSellerModel, networkManager: Networking) {
        model = bestSeller
        self.networkManager = networkManager
        isFavorites = model.isFavorites
    }
    
    var price: String {
        model.price != nil ? String.convertNumberInPrice(for: model.price! as NSNumber) : ""
    }
    
    var discountPrice: String {
        model.discountPrice != nil ? String.convertNumberInPrice(for: model.discountPrice! as NSNumber) : ""
    }
    
    var title: String {
        model.nameDevice
    }
    
    var isFavorite: Bool {
        isFavorites
    }
    
    func didTouchFavorites() {
        isFavorites.toggle()
        changedViewModel?(self)
    }

    func loadImageData() {
        networkManager.loadImageData(model.picture) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.viewImageData?(data)
            case .failure(_):
                print("error load image: \(self.model.picture)")
            }
        }
    }
    
    var changedViewModel: ((BestSellerCollectionCellViewModelProtocol) -> Void)?
    
    var viewImageData: ((Data)->Void)?
}
