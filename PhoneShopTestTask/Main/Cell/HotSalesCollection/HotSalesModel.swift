//
//  HotSalesModel.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 30.08.2022.
//

import Foundation

struct HotSalesModel {
    let id: Int
    let title: String
    let subtitle: String
    let picture: String
    let isNew: Bool
    let isBuy: Bool
    
    init(_ device: Device) {
        self.id = device.id
        self.title = device.title
        self.subtitle = device.subtitle ?? ""
        self.picture = device.picture
        self.isNew = device.isNew ?? false
        self.isBuy = device.isBuy ?? false
    }
}
