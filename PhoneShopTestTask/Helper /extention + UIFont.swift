//
//  extention + UIFont.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 09.09.2022.
//

import UIKit

extension UIFont {
    
    enum MarkProFontWeight: Int {
        case plain = 400
        case medium = 500
        case bold = 700
        case heavy = 800
        
        var nameFont: String {
            switch self {
            case .plain:
                return "MarkPro"
            case .medium:
                return "MarkPro-Medium"
            case .bold:
                return "MarkPro-Bold"
            case .heavy:
                return "MarkPro-Heavy"
            }
        }
    }
    
    static func markProFont(size fontSize: CGFloat, weight fontWeight: MarkProFontWeight) -> UIFont? {
        UIFont(name: fontWeight.nameFont, size: fontSize)
    }
}
