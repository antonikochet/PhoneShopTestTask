//
//  FilterOptionView.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 02.09.2022.
//

import UIKit

class FilterOptionView: UIView {
    
    var viewModel: FilterOptionViewModelProtocol! {
        didSet {
            viewModel.didChangeViewModel = { [weak self] viewModel in
                guard let self = self else { return }
                self.textField.text = viewModel.text
                if self.isEnabledPickerView {
                    self.pickerView.isHidden = true
                }
                self.setPositionSubview()
            }
            
            label.text = viewModel.name
            textField.text = viewModel.text
        }
    }
    
    var animateTimeHiddenPickerView: TimeInterval? = nil
    
    private let calculatorSizes = CalculatorContentView()
    private var isEnabledPickerView: Bool
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = CalculatorContentView.labelFont
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        return textField
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    init(isEnabledPicker: Bool = true) {
        self.isEnabledPickerView = isEnabledPicker
        super.init(frame: .zero)
        pickerView.isUserInteractionEnabled = isEnabledPicker
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        self.isEnabledPickerView = true
        super.init(coder: coder)
        setupSubViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.createBorder(radius: 8)
        textField.createRightButton(rightPadding: 10)
        textField.indentLeft(size: 10)
    }
    
    func setDelegate(sender: Any) {
        pickerView.delegate = sender as? UIPickerViewDelegate
        pickerView.dataSource = sender as? UIPickerViewDataSource
    }
    
    func isMyPickerView(_ pickerView: UIPickerView) -> Bool {
        self.pickerView == pickerView
    }
    
    func setupSizeSubviews() {
        heightAnchor.constraint(equalToConstant: 10).isActive = true
        setPositionSubview()
    }
    
    private func setPositionSubview() {
        let contentSizes = calculatorSizes.sizesView(widthView: superview?.frame.width ?? 0,
                                                isHiddenPicker: pickerView.isHidden)
        label.frame = contentSizes.labelFrame
        textField.frame = contentSizes.textFieldFrame
        if let pickerFrame = contentSizes.pickerViewFrame {
            pickerView.frame = pickerFrame
        }
        
        setHeight(contentSizes.heightView)
    }
    
    private func setupSubViews() {
        addSubview(label)
        addSubview(textField)
        addSubview(pickerView)
        
        textField.delegate = self
        
        pickerView.isHidden = true
    }
    
    private func setHeight(_ height: CGFloat) {
        if let constraint = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            constraint.constant = CGFloat(height)

            if let animateTime = animateTimeHiddenPickerView {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}

fileprivate extension FilterOptionView {
    struct CalculatorContentView {
        
        struct ContentSizes {
            var labelFrame: CGRect
            var textFieldFrame: CGRect
            var pickerViewFrame: CGRect?
            var heightView: CGFloat
        }
        
        private let labelInsets = UIEdgeInsets(top: 8, left: 46, bottom: 0, right: 31)
        private let textFieldInsets = UIEdgeInsets(top: 8, left: 46, bottom: 0, right: 31)
        private let pickerInsets = UIEdgeInsets(top: 0, left: 46, bottom: 0, right: 31)
        
        static let labelFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        func sizesView(widthView: CGFloat, isHiddenPicker: Bool) -> ContentSizes {
            var height: CGFloat = 0
            //label view frame
            let labelSize = CGSize(width: widthView - labelInsets.left - labelInsets.right,
                                  height: CalculatorContentView.labelFont.lineHeight)
            let labelFrame = CGRect(origin: CGPoint(x: labelInsets.left,
                                                    y: labelInsets.top),
                                    size: labelSize)
            height += labelSize.height + labelInsets.top
            
            //textField frame
            let textFieldSize = CGSize (width: widthView - textFieldInsets.left - textFieldInsets.right,
                                        height: 37)
            let textFieldFrame = CGRect(origin: CGPoint(x: textFieldInsets.left,
                                                        y: height + textFieldInsets.top),
                                        size: textFieldSize)
            height += textFieldSize.height + labelInsets.top
            
            var pickerFrame: CGRect? = nil
            //pickerView frame
            if !isHiddenPicker {
                let pickerSize = CGSize(width: widthView - pickerInsets.left - pickerInsets.right,
                                        height: 90)
                pickerFrame = CGRect(origin: CGPoint(x: pickerInsets.left,
                                                     y: height + pickerInsets.top),
                                         size: pickerSize)
                height += pickerSize.height + pickerInsets.top + pickerInsets.bottom
            }
            
            return ContentSizes(labelFrame: labelFrame,
                                textFieldFrame: textFieldFrame,
                                pickerViewFrame: pickerFrame,
                                heightView: height)
            
        }
    }
}

extension FilterOptionView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textField {
            if self.isEnabledPickerView {
                pickerView.isHidden = false
            }
            setPositionSubview()
            textField.endEditing(true)
        }
    }
}

fileprivate extension UITextField {
    func createRightButton(rightPadding: CGFloat) {
        let width: CGFloat = frame.height + rightPadding
        let view = UIView(frame: CGRect(x: frame.maxX - width, y: frame.minY, width: width, height: frame.height))
        
        let rightButton = UIButton(type: .custom)
        let image = UIImage(systemName: "chevron.down")
        rightButton.setImage(image, for: .normal)
        
        view.addSubview(rightButton)
        rightButton.frame = view.bounds
        
        rightButton.tintColor = .systemGray
        self.rightView = view
        self.rightViewMode = .always
        self.clearButtonMode = .never
    }
    
    func indentLeft(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func createBorder(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "gray")?.cgColor
    }
}
