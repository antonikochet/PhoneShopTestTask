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
    var numberOfPhotos: Int { get }
    var sectionsOfInfo: [String] { get }
    init(_ id: Int, networkManager: Networking)
    
    var didLoadDataForView: ((DetailsViewModelProtocol) -> Void)? { get set }
    var changedFavorites: (() -> Void)? { get set }
    var didLoadImage: (() -> Void)? { get set }
    func didTouchFavorites()
    func didTouchAddCart()
    func getImageData(at index: Int) -> Data?
}

class DetailsViewModel: DetailsViewModelProtocol {
    //MARK: private property
    private let networkManager: Networking
    private var id: Int
    private var detailsData: DetailsData?
    private var isFavorite: Bool = false
    private var imagesData: [Data] = []
    
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
    
    var numberOfPhotos: Int {
        imagesData.count
    }
    
    var sectionsOfInfo: [String] {
        return ["Shop", "Details", "Features"]
    }
    
    //MARK: protocol callback
    var didLoadDataForView: ((DetailsViewModelProtocol) -> Void)?
    var changedFavorites: (() -> Void)? 
    var didLoadImage: (() -> Void)?
    
    //MARK: init
    required init(_ id: Int, networkManager: Networking) {
        self.networkManager = networkManager
        self.id = id
        loadData()
    }
    
    //MARK: protocol methods
    
    func didTouchFavorites() {
        isFavorite.toggle()
        changedFavorites?()
    }
    
    func didTouchAddCart() {
        //TODO: добавить сюда добавление в хранилище инофрмацию
    }
    
    func getImageData(at index: Int) -> Data? {
        guard index <= imagesData.count || !imagesData.isEmpty else { return nil }
        return imagesData[index]
    }
    
    //MARK: private methods
    private func loadData() {
        networkManager.getDetailsScreenData(for: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.detailsData = data
                self.isFavorite = data.isFavorites
                self.didLoadDataForView?(self)
                self.loadImagesData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImagesData() {
        guard let detailsData = detailsData else { return }
        var count = detailsData.images.count
        for photoUrl in detailsData.images {
            networkManager.loadImageData(photoUrl) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.imagesData.append(data)
                    count -= 1
                case .failure(let error):
                    print("\(photoUrl) not load image, \(error)")
                    count -= 1
                }
                if count == 0 {
                    self?.didLoadImage?()
                }
                
            }
        }
    }
}
