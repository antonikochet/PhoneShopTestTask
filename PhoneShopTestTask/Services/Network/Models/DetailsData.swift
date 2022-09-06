//
//  DetailsData.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import Foundation

struct DetailsData: Decodable {
    let title: String
    let isFavorites: Bool
    let CPU: String
    let camera: String
    let sd: String
    let ssd: String
    let capacity: [String]
    let color: [String]
    let price: Int
    let images: [String]
}
