//
//  FilterOptionsViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 01.09.2022.
//

import UIKit

class FilterOptionsViewController: UIViewController {
    
    var viewModel: FilterOptionsViewModelProtocol!
    
    private let brandView: FilterOptionView = {
        let view = FilterOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceView: FilterOptionView = {
        let view = FilterOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sizeView: FilterOptionView = {
        let view = FilterOptionView(isEnabledPicker: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.title
        
        setupLeftButtonNavigationItem()
        setupRightButtonNavigationItem()
        
        setupBrandView()
        setupPriceView()
        setupSizeView()
    }
    
    private func setupLeftButtonNavigationItem() {
        let height = navigationController?.navigationBar.frame.height ?? 0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height / 1.5, height: height / 1.5))
        view.backgroundColor = UIColor(named: "blue")
        let imageView = UIImageView(frame: CGRect(x: view.frame.width / 3,
                                                  y: view.frame.height / 3,
                                                  width: view.frame.width / 3,
                                                  height: view.frame.height / 3))
        if let image = UIImage(systemName: "multiply") {
            imageView.image = image
            imageView.tintColor = .white
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(closeViewController))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupRightButtonNavigationItem() {
        let height = navigationController?.navigationBar.frame.height ?? 0
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: height / 1.5 * 2, height: height / 1.5))
        label.backgroundColor = UIColor(named: "orange")
        label.text = "Done"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.isUserInteractionEnabled = true

        let backTap = UITapGestureRecognizer(target: self, action: #selector(doneFilterViewController))
        label.addGestureRecognizer(backTap)

        let rightBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupBrandView() {
        view.addSubview(brandView)
        brandView.setDelegate(sender: self)
        brandView.viewModel = viewModel.getViewModel(for: .brand)
        
        brandView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        brandView.setupSizeSubviews()
    }
    
    private func setupPriceView() {
        view.addSubview(priceView)
        priceView.setDelegate(sender: self)
        priceView.viewModel = viewModel.getViewModel(for: .price)
        
        priceView.anchor(top: brandView.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        priceView.setupSizeSubviews()
    }
    
    private func setupSizeView() {
        view.addSubview(sizeView)
        sizeView.viewModel = viewModel.getViewModel(for: .size)
        sizeView.anchor(top: priceView.bottomAnchor,
                        leading: view.leadingAnchor,
                        bottom: nil,
                        trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        sizeView.setupSizeSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let view = navigationItem.leftBarButtonItem?.customView {
            view.layer.cornerRadius = 11
            view.clipsToBounds = true
        }
        
        if let view = navigationItem.rightBarButtonItem?.customView {
            view.layer.cornerRadius = 11
            view.clipsToBounds = true
        }
    }
    
    @objc private func closeViewController() {
        dismiss(animated: true)
    }
    
    @objc private func doneFilterViewController() {
        dismiss(animated: true) //изменить логику работы для возврата информации в основное окно для проведения фильтации
    }
}

extension FilterOptionsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if brandView.isMyPickerView(pickerView) {
            return viewModel.numberOfRows(.brand)
        } else if priceView.isMyPickerView(pickerView) {
            return viewModel.numberOfRows(.price)
        }
        return 0
    }
}

extension FilterOptionsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if brandView.isMyPickerView(pickerView) {
            return viewModel.getRowValue(at: row, for: .brand)
        } else if priceView.isMyPickerView(pickerView) {
            return viewModel.getRowValue(at: row, for: .price)
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if brandView.isMyPickerView(pickerView) {
            let newText = viewModel.getRowValue(at: row, for: .brand)
            brandView.viewModel.didChangeText(newText)
        } else if priceView.isMyPickerView(pickerView) {
            let newText = viewModel.getRowValue(at: row, for: .price)
            priceView.viewModel.didChangeText(newText)
        }
    }
}
