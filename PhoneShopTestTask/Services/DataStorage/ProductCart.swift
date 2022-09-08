//
//  ProductCart.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 08.09.2022.
//

import Foundation
import UIKit

struct ProductCart: Codable {
    let id: Int
    let name: String
    var count: Int
    let price: Int
    let image: String
    
    init(model bs: BestSellerModel) {
        self.id = bs.id
        self.name = bs.nameDevice
        self.count = 1
        self.price = bs.discountPrice ?? 0
        self.image = bs.picture
    }
    
    init(basketData: BasketCardData) {
        self.id = basketData.id
        self.name = basketData.title
        self.count = 1
        self.price = basketData.price
        self.image = basketData.images
    }
}
