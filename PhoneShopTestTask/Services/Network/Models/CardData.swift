//
//  CardData.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import Foundation

struct CardData: Decodable {
//    let id: Int
    let basket: [BasketCardData]
    let delivery: String
    let total: Int
}

struct BasketCardData: Decodable {
//    let id: Int
    let images: String
    let price: Int
    let title: String
}
