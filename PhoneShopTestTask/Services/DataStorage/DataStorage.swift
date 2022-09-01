//
//  DataStorage.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import Foundation

protocol DataStorageProtocol {
    func getCategory() -> [CategoryProduct]
}

struct DataStorage: DataStorageProtocol {
    
    static let shared = DataStorage()
    func getCategory() -> [CategoryProduct] {
        CategoryProduct.allCases
    }
}
