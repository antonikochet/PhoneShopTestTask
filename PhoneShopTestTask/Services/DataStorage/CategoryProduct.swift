//
//  CategoryProduct.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import Foundation

enum CategoryProduct: String, CaseIterable {
    case Phones, Computer, Health, Books
    
    var nameImage: String {
        switch self {
        case .Phones:
            return "iphone"
        case .Computer:
            return "desktopcomputer"
        case .Health:
            return "heart"
        case .Books:
            return "book"
        }
    }
}
