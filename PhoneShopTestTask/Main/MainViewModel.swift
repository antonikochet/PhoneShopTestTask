//
//  MainViewModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 01.09.2022.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    
}

class MainViewModel: MainViewModelProtocol {
    private let categories: [CategoryProduct]
    private var selectedCategory: CategoryProduct
    private var hotSalesModels: [HotSalesModel] = []
    private var bestSellesModels: [BestSellerModel] = []
    
    private var didLoadBestSellerData: ((Bool) -> Void)?
    private var didLoadHotSalesData: ((Bool) -> Void)?
    
    init() {
        categories = DataStorage.shared.getCategory()
        selectedCategory = .Phones
        loadData()
    }
    
    private func loadData() {
        NetworkManager.shared.getMainScreenData { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let mainScreenData):
                strongSelf.hotSalesModels = mainScreenData.homeStore.map { HotSalesModel($0) }
                strongSelf.bestSellesModels = mainScreenData.bestSeller.map { BestSellerModel($0) }
                strongSelf.didLoadBestSellerData?(true)
                strongSelf.didLoadHotSalesData?(true)
            case .failure(let error):
                print(error)
                strongSelf.didLoadHotSalesData?(false)
                strongSelf.didLoadBestSellerData?(true)
            }
        }
    }
}

extension MainViewModel: CategoryTableCellViewModelProtocol {
    var numberCategories: Int {
        categories.count
    }
    
    func getViewModel(at index: Int) -> CategoryCollectionCellViewModelProcorol {
        let product = categories[index]
        let isSelect = product == selectedCategory
        return CategoryCollectionCellViewModel(product, isSelect: isSelect)
    }
    
    var indexSelectedItem: Int {
        return categories.firstIndex(of: selectedCategory) ?? 0
    }
    
    func didSelectedItem(at index: Int) {
        let product = categories[index]
        selectedCategory = product
    }
}

extension MainViewModel: HotSalesTableCellViewModelProtorol {
    var numberOfRowsHotSales: Int {
        hotSalesModels.count
    }
    
    func getHotSalesViewModel(at index: Int) -> HotSalesCollectionCellViewModelProtocol {
        HotSalesCollectionCellViewModel(model: hotSalesModels[index])
    }
    
    var didLoadDataForHotSales: ((Bool) -> Void)? {
        get { didLoadHotSalesData }
        set { didLoadHotSalesData = newValue }
    }
    
}

extension MainViewModel: BestSellerTableCellViewModelProtorol {
    var numberOfRowsBestSeller: Int {
        bestSellesModels.count
    }
    
    func getBestSellerViewModel(at index: Int) -> BestSellerCollectionCellViewModelProtocol {
        BestSellerCollectionCellViewModel(bestSellesModels[index])
    }
    
    var didLoadDataForBestSeller: ((Bool) -> Void)? {
        get { didLoadBestSellerData }
        set { didLoadBestSellerData = newValue }
    }
    
}
