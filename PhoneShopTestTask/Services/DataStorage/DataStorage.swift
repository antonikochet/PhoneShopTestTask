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
    
    func getProductsCart() -> [ProductCart]
    func setProductsCart(_ array: [ProductCart])
    func setProductCart(id: Int, product: ProductCart)
    func getCountProducts() -> Int
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
    
    func getProductsCart() -> [ProductCart] {
        guard let data = UserDefaults.standard.object(forKey: NameKeyUserDefaults.devices.rawValue) as? Data,
              let array = try? PropertyListDecoder().decode([ProductCart].self, from: data)  else { return [] }
        
        return array
    }
    
    func setProductsCart(_ array: [ProductCart]) {
        let encodeData = try? PropertyListEncoder().encode(array)
        UserDefaults.standard.set(encodeData, forKey: NameKeyUserDefaults.devices.rawValue)
    }
    
    func setProductCart(id: Int, product: ProductCart) {
        var products = getProductsCart()
        guard !products.isEmpty,
              let index = products.firstIndex(where: { $0.id == id }) else { return }
        products[index] = product
        setProductsCart(products)
    }
    
    func getCountProducts() -> Int {
        let array = getProductsCart()
        return array.reduce(0, { $0 + $1.count })
    }
    
    enum NameKeyUserDefaults: String {
        case devices
    }
}
