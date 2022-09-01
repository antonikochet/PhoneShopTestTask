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
    
    init(_ bestSeller: BestSellerModel)
    
    func didTouchFavorites()
    func loadImageData()
    var changedViewModel: ((BestSellerCollectionCellViewModelProtocol) -> Void)? { get set }
    var viewImageData: ((Data)->Void)? { get set }
}

class BestSellerCollectionCellViewModel: BestSellerCollectionCellViewModelProtocol {
    private let model: BestSellerModel
    private var isFavorites: Bool
    
    required init(_ bestSeller: BestSellerModel) {
        model = bestSeller
        isFavorites = model.isFavorites
    }
    
    var price: String {
        model.price != nil ? "$\(String(model.price!))" : ""
    }
    
    var discountPrice: String {
        model.discountPrice != nil ? "$\(String(model.discountPrice!))" : ""
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
        NetworkManager.shared.loadImageData(model.picture) {[weak self] result in
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
