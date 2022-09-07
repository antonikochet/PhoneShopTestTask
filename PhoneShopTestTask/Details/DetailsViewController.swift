//
//  DetailsViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 03.09.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var viewModel: DetailsViewModelProtocol! {
        didSet {
            viewModel.didLoadDataForView = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.setContentSubview()
                }
            }
            
            viewModel.changedFavorites = { [weak self] in
                DispatchQueue.main.async {
                    self?.drawFavoritesButton()
                }
            }
            
            viewModel.didLoadImage = { [weak self] in
                DispatchQueue.main.async {
                    guard let photoVC = self?.photoDetailsViewController(at: 0) else { return }
                    self?.photosPageViewController.setViewControllers([photoVC], direction: .forward, animated: true)
                    self?.photosPageViewController.view.isHidden = false
                    self?.photoActivityIndicatorView.stopAnimating()
                }
            }
            
        }
    }
    //MARK: photoView
    private let photoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let photoActivityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private let photosPageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    
    //MARK: top bottomView
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameDeviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.clipsToBounds = true
        button.backgroundColor = UIColor(named: "blue")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: center bottomView
    private let menuInfoDeviceSegmentControl: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.backgroundColor = .clear
        segmented.tintColor = .clear
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 20, weight: .light),
            .foregroundColor : UIColor(white: 0, alpha: 0.5)
        ]
        segmented.setTitleTextAttributes(attributes, for: .normal)

        let selectedAttrib: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor : UIColor(white: 0, alpha: 1)]
        segmented.setTitleTextAttributes(selectedAttrib, for: .selected)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private let selectedItemMenuInfoDeviceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "orange")
        return view
    }()
    
    private let detailsInfoDeviceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: bottom bottomView
    private let selectColorAndCapacityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Select color and capacity"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectedColorsView: SelectColorsView = {
        let view = SelectColorsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 18
        return view
    }()
    
    private let capacitySegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.tintColor = UIColor(named: "orange")
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor : UIColor(white: 141/255, alpha: 1)
        ]
        segmented.setTitleTextAttributes(attributes, for: .normal)

        let selectedAttrib: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor : UIColor(white: 1, alpha: 1)
        ]
        segmented.setTitleTextAttributes(selectedAttrib, for: .selected)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private let addCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: override view`s methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Product Detailes"
        
        view.backgroundColor = UIColor(white: 248/255, alpha: 0.95)
        
        createLeftButton(type: .back, selector: #selector(didTouchBackButton), ratioButtonToNavBar: 37.0/44.0, ratioSize: 0.55)
        createRightButton(type: .cart, selector: #selector(didTouchCartViewButton), ratioButtonToNavBar: 37.00/44.0, ratioSize: 0.55)
        
        setupBottomView()
        setupPhotosPageView()
        setContentSubview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let radius: CGFloat = 40
        let path = UIBezierPath(roundedRect:bottomView.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()

        photosPageViewController.view.layer.cornerRadius = 20
        photosPageViewController.view.clipsToBounds = true
        
        maskLayer.path = path.cgPath
        bottomView.layer.mask = maskLayer
        
        if let view = navigationItem.leftBarButtonItem?.customView {
            view.layer.cornerRadius = 11
            view.clipsToBounds = true
        }
        if let view = navigationItem.rightBarButtonItem?.customView {
            view.layer.cornerRadius = 11
            view.clipsToBounds = true
        }
        
        favoritesButton.layer.cornerRadius = 10
        
        drawSelectedItemMenuView(at: menuInfoDeviceSegmentControl.selectedSegmentIndex)
        selectedItemMenuInfoDeviceView.layer.cornerRadius = selectedItemMenuInfoDeviceView.frame.height / 2
        selectedItemMenuInfoDeviceView.clipsToBounds = true
        
        _ = capacitySegmentedControl.subviews.compactMap {
            if $0.frame.width > 0{
                $0.layer.cornerRadius = 10
                $0.clipsToBounds = true
            }
        }
        
        addCartButton.layer.cornerRadius = 10
        addCartButton.clipsToBounds = true
    }
    
    //MARK: setups
    private func setupPhotosPageView() {
        view.addSubview(photoView)
        photoView.addSubview(photoActivityIndicatorView)
        photoActivityIndicatorView.centerXAnchor.constraint(equalTo: photoView.centerXAnchor).isActive = true
        photoActivityIndicatorView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            photoView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8),
            photoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            photoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        photosPageViewController.dataSource = self
        
        addChild(photosPageViewController)
        photosPageViewController.didMove(toParent: self)
        
        photosPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        photoView.addSubview(photosPageViewController.view)
        photosPageViewController.view.isHidden = true
        photosPageViewController.view.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        photosPageViewController.view.backgroundColor = .white
    }
    
    private func setupBottomView() {
        view.addSubview(bottomView)
        
        //bottomView
        bottomView.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.bottomAnchor,
                          trailing: view.trailingAnchor)
        bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.48).isActive = true
        
        setupTopBottomView()
        setupCenterBottomView()
        setupBottomBottomView()
    }
    
    private func setupTopBottomView() {
        //nameDeviceLabel
        bottomView.addSubview(nameDeviceLabel)
        nameDeviceLabel.anchor(top: bottomView.topAnchor,
                               leading: bottomView.leadingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 28, left: 38, bottom: 0, right: 0))
        
        nameDeviceLabel.heightAnchor.constraint(equalToConstant: nameDeviceLabel.font.lineHeight).isActive = true
        nameDeviceLabel.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7).isActive = true
        
        //favoritesButton
        bottomView.addSubview(favoritesButton)
        favoritesButton.anchor(top: nameDeviceLabel.topAnchor,
                               leading: nameDeviceLabel.trailingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                               size: CGSize(width: 37, height: 33))
        favoritesButton.addTarget(self, action: #selector(didTouchFavoritesButton), for: .touchUpInside)
        
        //starsStackView
        bottomView.addSubview(starsStackView)
        starsStackView.anchor(top: nameDeviceLabel.bottomAnchor,
                              leading: nameDeviceLabel.leadingAnchor,
                              bottom: nil,
                              trailing: bottomView.centerXAnchor,
                              padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 10))
        starsStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        for _ in 1...5 {
            let imageView = UIImageView()
            let image = UIImage(systemName: "star.fill")
            imageView.image = image
            imageView.tintColor = UIColor(red: 1, green: 184/255, blue: 0, alpha: 1)
            starsStackView.addArrangedSubview(imageView)
        }

    }
    
    private func setupCenterBottomView() {
        //menuInfoDeviceSegmentControl
        bottomView.addSubview(menuInfoDeviceSegmentControl)
        menuInfoDeviceSegmentControl.anchor(top: starsStackView.bottomAnchor,
                                       leading: nameDeviceLabel.leadingAnchor,
                                       bottom: nil,
                                       trailing: favoritesButton.trailingAnchor,
                                       padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        menuInfoDeviceSegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        for (index,item) in viewModel.sectionsOfInfo.enumerated() {
            menuInfoDeviceSegmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        menuInfoDeviceSegmentControl.removeBorders()
        menuInfoDeviceSegmentControl.selectedSegmentIndex = 0
        menuInfoDeviceSegmentControl.addTarget(self, action: #selector(changeValueMenuInfoSegmentedControl), for: .valueChanged)
        
        //selectedItemMenuInfoDeviceView
        bottomView.addSubview(selectedItemMenuInfoDeviceView)
        
        //detailsInfoDeviceStackView
        bottomView.addSubview(detailsInfoDeviceStackView)
        detailsInfoDeviceStackView.anchor(top: menuInfoDeviceSegmentControl.bottomAnchor,
                                          leading: nameDeviceLabel.leadingAnchor,
                                          bottom: nil,
                                          trailing: favoritesButton.trailingAnchor,
                                          padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        detailsInfoDeviceStackView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.20).isActive = true
        for _ in 0..<DetailsInfoDevice.allCases.count {
            let view = DetailsInfoView()
            detailsInfoDeviceStackView.addArrangedSubview(view)
        }
        
    }
    
    private func setupBottomBottomView() {
        //selectColorAndCapacityLabel
        bottomView.addSubview(selectColorAndCapacityLabel)
        selectColorAndCapacityLabel.anchor(top: detailsInfoDeviceStackView.bottomAnchor,
                                           leading: nameDeviceLabel.leadingAnchor,
                                           bottom: nil,
                                           trailing: favoritesButton.trailingAnchor,
                                           padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        selectColorAndCapacityLabel.heightAnchor.constraint(equalToConstant: selectColorAndCapacityLabel.font.lineHeight).isActive = true
        
        //selectedColorsView
        bottomView.addSubview(selectedColorsView)
        selectedColorsView.anchor(top: selectColorAndCapacityLabel.bottomAnchor,
                              leading: nameDeviceLabel.leadingAnchor,
                              bottom: nil,
                              trailing: bottomView.centerXAnchor,
                              padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 10))
        selectedColorsView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //capacitySegmentedControl
        bottomView.addSubview(capacitySegmentedControl)
        capacitySegmentedControl.anchor(top: nil,
                                        leading: bottomView.centerXAnchor,
                                        bottom: nil,
                                        trailing: favoritesButton.trailingAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        capacitySegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        capacitySegmentedControl.centerYAnchor.constraint(equalTo: selectedColorsView.centerYAnchor).isActive = true
        capacitySegmentedControl.removeBorders()
        
        //addCartButton
        bottomView.addSubview(addCartButton)
        addCartButton.anchor(top: selectedColorsView.bottomAnchor,
                             leading: nameDeviceLabel.leadingAnchor,
                             bottom: bottomView.safeAreaLayoutGuide.bottomAnchor,
                             trailing: favoritesButton.trailingAnchor,
                             padding: UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0))
        
        addCartButton.addTarget(self, action: #selector(didTouchAddCartButton), for: .touchUpInside)
    }
    
    //MARK: private methods
    private func setContentSubview() {
        nameDeviceLabel.text = viewModel.nameDevice
        drawFavoritesButton()
        
        for item in DetailsInfoDevice.allCases {
            guard let view = detailsInfoDeviceStackView.arrangedSubviews[item.rawValue] as? DetailsInfoView else { continue }
            switch item {
            case .CPU:
                view.set(item, text: viewModel.CPU)
            case .camera:
                view.set(item, text: viewModel.camera)
            case .ssd:
                view.set(item, text: viewModel.ssd)
            case .sd:
                view.set(item, text: viewModel.sd)
            }
        }
        
        selectedColorsView.set(colors: viewModel.color)
        
        if capacitySegmentedControl.numberOfSegments == 0 {
            for (index, item) in viewModel.capacity.enumerated() {
                capacitySegmentedControl.insertSegment(withTitle: item, at: index, animated: true)
            }
            capacitySegmentedControl.selectedSegmentIndex = 0
        } else if capacitySegmentedControl.numberOfSegments == viewModel.capacity.count {
            for (index, item) in viewModel.capacity.enumerated() {
                capacitySegmentedControl.setTitle(item, forSegmentAt: index)
            }
        }
        
        addCartButton.setTitle(viewModel.price, for: .normal)
        
        photoActivityIndicatorView.startAnimating()
    }
    
    private func photoDetailsViewController(at index: Int) -> PhotoDetailsViewController? {
        if index >= viewModel.numberOfPhotos || viewModel.numberOfPhotos == 0 {
            return nil
        }
        
        let photoVC = PhotoDetailsViewController()
        photoVC.index = index
        photoVC.set(image: viewModel.getImageData(at: index))
        return photoVC
    }
    
    private func drawFavoritesButton() {
        favoritesButton.setImage(viewModel.isFavorites ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    private func drawSelectedItemMenuView(at index: Int) {
        let frame = menuInfoDeviceSegmentControl.frame
        let widthSegment = frame.width / CGFloat(menuInfoDeviceSegmentControl.numberOfSegments)
        
        let size = CGSize(width: widthSegment, height: 5)
        let originSegment = CGPoint(x: frame.minX + CGFloat(index) * widthSegment,
                                    y: frame.maxY)
        UIView.animate(withDuration: 0.4) {
            self.selectedItemMenuInfoDeviceView.frame = CGRect(origin: originSegment,
                                                          size: size)
        }
    }
    
    @objc private func didTouchFavoritesButton() {
        viewModel.didTouchFavorites()
    }
    
    @objc private func changeValueMenuInfoSegmentedControl() {
        let index = menuInfoDeviceSegmentControl.selectedSegmentIndex
        drawSelectedItemMenuView(at: index)
    }
    
    @objc private func didTouchAddCartButton() {
        viewModel.didTouchAddCart()
    }
    
    @objc private func didTouchBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTouchCartViewButton() {
        let configurator = CartConfigurator()
        let vc = configurator.configure()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailsViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let photoVC = viewController as? PhotoDetailsViewController
        guard let currectIndex = photoVC?.index,
              currectIndex != 0 else { return nil }
        
        return photoDetailsViewController(at: currectIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let photoVC = viewController as? PhotoDetailsViewController
        guard let currectIndex = photoVC?.index,
              currectIndex != viewModel.numberOfPhotos else { return nil }
        
        return photoDetailsViewController(at: currectIndex + 1)
    }
}

fileprivate extension UISegmentedControl {
    func removeBorders(andBackground:Bool=false) {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

