//
//  extention + String.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 05.09.2022.
//

import Foundation

extension String {
    static func convertNumberInPrice(for number: NSNumber, isOutDouble: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = isOutDouble ? 2 : 0
        formatter.maximumFractionDigits = 2
        if let stringNumber = formatter.string(from: number) {
            return "$\(stringNumber)"
        } else {
            return ""
        }
    }
}
