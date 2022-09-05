//
//  DetailsViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import Foundation

protocol DetailsViewModelProtocol {
    var nameDevice: String { get }
    var isFavorites: Bool { get }
    var CPU: String { get }
    var camera: String { get }
    var sd: String { get }
    var ssd: String { get }
    var capacity: [String] { get }
    var color: [String] { get }
    var price: String { get }
    var sectionsOfInfo: [String] { get }
    init(_ id: Int)
    
    var didLoadDataForView: ((DetailsViewModelProtocol) -> Void)? { get set }
    var changedFavorites: (() -> Void)? { get set }
    func didTouchFavorites()
    func didTouchAddCart()
}

class DetailsViewModel: DetailsViewModelProtocol {
    //MARK: private property
    private var id: Int
    private var detailsData: DetailsData?
    private var isFavorite: Bool = false
    //MARK: protocol property
    var nameDevice: String {
        detailsData?.title ?? ""
    }
    
    var isFavorites: Bool {
        isFavorite
    }
    
    var CPU: String {
        detailsData?.CPU ?? ""
    }
    
    var camera: String {
        detailsData?.camera ?? ""
    }
    
    var sd: String {
        detailsData?.sd ?? ""
    }
    
    var ssd: String {
        detailsData?.ssd ?? ""
    }
    
    var capacity: [String] {
        detailsData?.capacity.map { $0 + " GB"} ?? []
    }
    
    var color: [String] {
        detailsData?.color ?? []
    }
    
    var price: String {
        let title = "Add to Cart"
        let tap = String(repeating: " ", count: 10)
        if let price = detailsData?.price {
            return title + tap + String.convertNumberInPrice(for: price as NSNumber, isOutDouble: true)
        } else {
            return title + tap
        }
    }
    
    var sectionsOfInfo: [String] {
        return ["Shop", "Details", "Features"]
    }
    
    //MARK: protocol callback
    var didLoadDataForView: ((DetailsViewModelProtocol) -> Void)?
    var changedFavorites: (() -> Void)? 
    
    //MARK: init
    required init(_ id: Int) {
        self.id = id
        loadData()
    }
    
    //MARK: protocol methods
    
    func didTouchFavorites() {
        isFavorite.toggle()
        changedFavorites?()
    }
    
    func didTouchAddCart() {
        
    }
    //MARK: private methods
    private func loadData() {
        NetworkManager.shared.getDetailsScreenData(for: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.detailsData = data
                self.isFavorite = data.isFavorites
                self.didLoadDataForView?(self)
            case .failure(let error):
                print(error)
            }
        }
    }
}
