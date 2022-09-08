//
//  CartViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 07.09.2022.
//

import UIKit

class CartViewController: UIViewController {

    var viewModel: CartViewModelProtocol! {
        didSet {
            viewModel.updateViews = { [weak self] viewModel in
                DispatchQueue.main.async {
                    self?.totalLabel.text = viewModel.total
                    self?.deliveryLabel.text = viewModel.delivety
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Cart"
        label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor(named: "orange")
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let totalLabel: UILabel = UILabel.createTotalAndDeliveryLabel(with: "1000", weight: .heavy)
    
    private let deliveryLabel: UILabel = UILabel.createTotalAndDeliveryLabel(with: "free", weight: .heavy)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        
        createLeftButton(type: .back, selector: #selector(didTouchBackButton), ratioButtonToNavBar: 37.0/44.0)
        createRightButton(type: .location, selector: #selector(didTouchLocationButton), ratioButtonToNavBar: 37.0/44.0, ratioSize: 0.6)
        setupRightNavigationButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.layer.cornerRadius = 30
        bottomView.clipsToBounds = true
        
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.clipsToBounds = true
        
        if let view = navigationItem.rightBarButtonItems?.first?.customView {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
        
        if let view = navigationItem.leftBarButtonItem?.customView {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
    }
    
    private func setupSubview() {
        view.addSubview(nameLabel)
        view.addSubview(bottomView)
        
        view.backgroundColor = UIColor(white: 248/255, alpha: 1)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: bottomView.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 48, left: 40, bottom: 48, right: 0))
        
        bottomView.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.bottomAnchor,
                          trailing: view.trailingAnchor)
        bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.73).isActive = true
        
        bottomView.addSubview(checkoutButton)
        checkoutButton.anchor(top: nil,
                              leading: bottomView.leadingAnchor,
                              bottom: bottomView.safeAreaLayoutGuide.bottomAnchor,
                              trailing: bottomView.trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 44, bottom: 16, right:44),
                              size: CGSize(width: 0, height: 54))
        
        let topLineCheckoutButtonView = UIView()
        bottomView.addSubview(topLineCheckoutButtonView)
        topLineCheckoutButtonView.translatesAutoresizingMaskIntoConstraints = false
        topLineCheckoutButtonView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        topLineCheckoutButtonView.anchor(top: nil,
                                         leading: bottomView.leadingAnchor,
                                         bottom: checkoutButton.topAnchor,
                                         trailing: bottomView.trailingAnchor,
                                         padding: UIEdgeInsets(top: 0, left: 8, bottom: 28, right: 8),
                                         size: CGSize(width: 0, height: 2))
        
        let stackView = setupTotalAndDeliveryLabel()
        bottomView.addSubview(stackView)
        stackView.anchor(top: nil,
                         leading: bottomView.leadingAnchor,
                         bottom: topLineCheckoutButtonView.topAnchor,
                         trailing: bottomView.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 55, bottom: 26, right: 35),
                         size: CGSize(width: 0, height: 75))
        
        let topLineStackView = UIView()
        bottomView.addSubview(topLineStackView)
        topLineStackView.translatesAutoresizingMaskIntoConstraints = false
        topLineStackView.backgroundColor = UIColor(white: 1, alpha: 0.25)
        topLineStackView.anchor(top: nil,
                                leading: bottomView.leadingAnchor,
                                bottom: stackView.topAnchor,
                                trailing: bottomView.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8),
                                size: CGSize(width: 0, height: 3))
        
        bottomView.addSubview(tableView)
        tableView.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: topLineStackView.topAnchor,
                         trailing: bottomView.trailingAnchor,
                         padding: UIEdgeInsets(top: 80, left: 16, bottom: 8, right: 16))
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.didLoadView()
    }
    
    private func setupTotalAndDeliveryLabel() -> UIStackView {
        let mainStackView = setupStackView(axis: .horizontal)
        mainStackView.distribution = .fillProportionally
        
        let leftStackView = setupStackView(axis: .vertical)
        let rightStackView = setupStackView(axis: .vertical)
        rightStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        leftStackView.addArrangedSubview(UILabel.createTotalAndDeliveryLabel(with: "Total", weight: .medium))
        leftStackView.addArrangedSubview(UILabel.createTotalAndDeliveryLabel(with: "Delivery", weight: .medium))
        
        rightStackView.addArrangedSubview(totalLabel)
        rightStackView.addArrangedSubview(deliveryLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        return mainStackView
    }
    
    private func setupStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }
    
    private func setupRightNavigationButtons() {
        guard let rightButton = navigationItem.rightBarButtonItem else { return }
        let label = UILabel()
        label.text = "Add address"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let labelButton = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItems = [rightButton, labelButton]
    }
    
    @objc private func didTouchBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTouchLocationButton() {
        
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfBasket
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        if let viewModel = viewModel.getCartCellViewModel(at: indexPath.row) {
            cell.viewModel = viewModel
        }
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
}

fileprivate extension UILabel {
    static func createTotalAndDeliveryLabel(with text: String?, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: weight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
