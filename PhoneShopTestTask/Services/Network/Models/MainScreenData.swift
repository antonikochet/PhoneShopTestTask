//
//  MainScreen.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 30.08.2022.
//

import Foundation

struct MainScreenData: Decodable {
    let homeStore: [Device]
    let bestSeller: [Device]
}

struct Device: Decodable {
    let id: Int
    let title: String
    let picture: String
    
    let isNew: Bool?
    let isBuy: Bool?
    let subtitle: String?

    let isFavorites: Bool?
    let priceWithoutDiscount: Int?
    let discountPrice: Int?
}
