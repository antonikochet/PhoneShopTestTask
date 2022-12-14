//
//  BestSellerModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 31.08.2022.
//

import Foundation

struct BestSellerModel {
    let id: Int
    let nameDevice: String
    let price: Int?
    let discountPrice: Int?
    let picture: String
    let isFavorites: Bool
    
    init(_ device: Device) {
        id = device.id
        nameDevice = device.title
        price = device.discountPrice
        discountPrice = device.priceWithoutDiscount
        picture = device.picture
        isFavorites = device.isFavorites ?? false
    }
}
