//
//  HotSalesCollectionCellViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 01.09.2022.
//

import Foundation

protocol HotSalesCollectionCellViewModelProtocol {
    init(model: HotSalesModel)
    var isNew: Bool { get }
    var isBuy: Bool { get }
    var brand: String { get }
    var desctiption: String { get }
    
    func loadImageData()
    
    var viewImageData: ((Data)->Void)? { get set }
}

class HotSalesCollectionCellViewModel: HotSalesCollectionCellViewModelProtocol {
    private let model: HotSalesModel
    
    required init(model: HotSalesModel) {
        self.model = model
    }
    
    var isNew: Bool {
        model.isNew
    }
    
    var isBuy: Bool {
        model.isBuy
    }
    
    var brand: String {
        model.title
    }
    
    var desctiption: String {
        model.subtitle
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
    
    var viewImageData: ((Data)->Void)?
}
