//
//  CategoryProduct.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import Foundation

enum CategoryProduct: String, CaseIterable {
    case Phones, Computer, Heart, Books, Other
    
    var nameImage: String {
        switch self {
        case .Phones:
            return "phone"
        case .Computer:
            return "computer"
        case .Heart:
            return "heart"
        case .Books:
            return "books"
        case .Other:
            return "other"
        }
    }
}
