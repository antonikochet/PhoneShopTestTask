//
//  extention + UIViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 05.09.2022.
//

import UIKit

extension UIViewController {
    
    enum TypeLeftButton {
        case close
        case back
    }
    
    enum TypeRightButton {
        case cart
        case location
    }
    
    func createLeftButton(type: TypeLeftButton, selector: Selector, ratioButtonToNavBar: CGFloat, ratioSize: CGFloat = 0.5) {
        let height = navigationController?.navigationBar.frame.height ?? 0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height * ratioButtonToNavBar,
                                        height: height * ratioButtonToNavBar))
        view.backgroundColor = UIColor(named: "blue")
        let imageView = UIImageView(frame: CGRect(x: view.frame.width *  ratioSize / 2,
                                                  y: view.frame.height * ratioSize / 2,
                                                  width: view.frame.width * (1 - ratioSize),
                                                  height: view.frame.height * (1 - ratioSize)))
        imageView.contentMode = .scaleAspectFit
        let image: UIImage?
        switch type {
        case .close:
            image = UIImage(systemName: "multiply")
        case .back:
            image = UIImage(systemName: "chevron.backward")
        }
        if let image = image {
            imageView.image = image
            imageView.tintColor = .white
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func createRightButton(withTitle title: String, selector: Selector, ratioButtonToNavBar: CGFloat) {
        let height = navigationController?.navigationBar.frame.height ?? 0
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: height / 1.5 * 2, height: height / 1.5))
        label.backgroundColor = UIColor(named: "orange")
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.markProFont(size: 18, weight: .medium)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        
        let backTap = UITapGestureRecognizer(target: self, action: selector)
        label.addGestureRecognizer(backTap)
        let rightBarButtonItem = UIBarButtonItem(customView: label)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func createRightButton(type: TypeRightButton, selector: Selector, ratioButtonToNavBar: CGFloat, ratioSize: CGFloat = 0.5) {
        let height = navigationController?.navigationBar.frame.height ?? 0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height * ratioButtonToNavBar,
                                        height: height * ratioButtonToNavBar))
        view.backgroundColor = UIColor(named: "orange")
        let imageView = UIImageView(frame: CGRect(x: view.frame.width *  ratioSize / 2,
                                                  y: view.frame.height * ratioSize / 2,
                                                  width: view.frame.width * (1 - ratioSize),
                                                  height: view.frame.height * (1 - ratioSize)))
        imageView.contentMode = .scaleAspectFit
        let image: UIImage?
        switch type {
        case .cart:
            image = UIImage(named: "bag")
        case .location:
            image = UIImage(named: "location")
        }
        if let image = image {
            imageView.image = image
            imageView.tintColor = .white
        }
        view.addSubview(imageView)
        let backTap = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(backTap)
        let rightBarButtonItem = UIBarButtonItem(customView: view)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
