//
//  PhotoDetailsViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 06.09.2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    var index: Int?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        imageView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func set(image: Data?) {
        guard let image = image,
              let i = UIImage(data: image) else { return }
        imageView.image = i
    }
}
