//
//  CounterView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import UIKit

class CounterView: UIView {
    
    var counter: String {
        didSet {
            countLabel.text = counter
        }
    }
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.markProFont(size: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(_ startCount: String) {
        counter = startCount
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        counter = "1"
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 67/255, alpha: 1)
        
        addSubview(minusButton)
        addSubview(countLabel)
        addSubview(plusButton)
        
        minusButton.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: nil,
                           trailing: trailingAnchor,
                           padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        minusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
        
        
        countLabel.anchor(top: minusButton.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: plusButton.topAnchor,
                          trailing: trailingAnchor)
        
        plusButton.anchor(top: nil,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0))
        plusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
    }

    func addTargerButton(target: Any?, plusSelector: Selector, minusSelector: Selector) {
        
        plusButton.addTarget(target, action: plusSelector, for: .touchUpInside)
        minusButton.addTarget(target, action: minusSelector, for: .touchUpInside)
    }
}
