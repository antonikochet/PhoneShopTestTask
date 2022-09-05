//
//  SelectColorsView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 05.09.2022.
//

import UIKit

//добавить scroll для возможного выхода за границы ограничений view
class SelectColorsView: UIView {
    //MARK: private properties
    private var selectedButton: Int = -1
    
    //MARK: public properties
    var spacing: CGFloat = 0 {
        didSet {
            for (index, button) in subviews.enumerated() {
                drawSubview(button as! UIButton, at: index, color: nil)
            }
        }
    }
    
    //MARK: init
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true
        }
    }
    
    //MARK: publuc methods
    func set(colors: [String]) {
        if subviews.isEmpty {
            selectedButton = 0
            forEach(colors, isCreatedButton: false)
        } else if subviews.count == colors.count {
            forEach(colors, isCreatedButton: true)
        } else {
            removeAll()
            selectedButton = 0
            forEach(colors, isCreatedButton: false)
        }
        
    }
    
    //MARK: private methods
    
    private func drawSubview(_ button: UIButton, at index: Int, color: String?) {
        let size = CGSize(width: frame.height, height: frame.height)
        
        let x = CGFloat(index) * (size.width + spacing)
        
        let frame = CGRect(origin: CGPoint(x: x,
                                           y: bounds.minY),
                           size: size)
        
        button.frame = frame
        if let color = color {
            button.backgroundColor = UIColor(hex: color)
        }
        if index == selectedButton {
            let image = UIImage(named: "checkMark")
            button.setImage(image, for: .normal)
        }
    }
    
    private func forEach(_ colors: [String], isCreatedButton: Bool) {
        for (index, color) in colors.enumerated() {
            let button: UIButton = isCreatedButton ? subviews[index] as! UIButton : UIButton()
            if !isCreatedButton {
                button.addTarget(self, action: #selector(didTouchButton(_:)), for: .touchUpInside)
                addSubview(button)
            }
            drawSubview(button, at: index, color: color)
        }
    }
    
    private func removeAll() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    @objc private func didTouchButton(_ touchButton: UIButton) {
        for (index,view) in subviews.enumerated() {
            let button = view as! UIButton
            if button == touchButton {
                selectedButton = index
                let image = UIImage(named: "checkMark")
                button.setImage(image, for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
}

fileprivate extension UIColor {
    convenience init?(hex: String) {
            let r, g, b: CGFloat

            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])

                if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        
                        self.init(red: r, green: g, blue: b, alpha: 1)
                        return
                    }
                }
            }

            return nil
        }
}
