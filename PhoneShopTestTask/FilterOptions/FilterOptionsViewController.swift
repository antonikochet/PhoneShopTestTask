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
        
        createLeftButton(type: .close, selector: #selector(closeViewController), ratioButtonToNavBar: 37.0/56.0, ratioSize: 0.66)
        createRightButton(withTitle: "Done", selector: #selector(doneFilterViewController), ratioButtonToNavBar: 37.0/56.0)
        
        setupBrandView()
        setupPriceView()
        setupSizeView()
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
