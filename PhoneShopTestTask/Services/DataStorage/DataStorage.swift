//
//  DataStorage.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import Foundation

protocol DataStorageProtocol {
    func getCategory() -> [CategoryProduct]
    func getBrandsForFilter() -> [String]
    func getPricesForFilter() -> [String]
    func getSizesForFilter() -> [String]
}

struct DataStorage: DataStorageProtocol {
    func getCategory() -> [CategoryProduct] {
        CategoryProduct.allCases
    }
    
    func getBrandsForFilter() -> [String] {
        ["Samsung", "Xiaomi"]
    }
    
    func getPricesForFilter() -> [String] {
        ["100-300", "300-500", "500-1000",
         "1000-5000", "5000-10000"]
    }
    
    func getSizesForFilter() -> [String] {
        ["4.5 to 5.5 inches"]
    }
}
