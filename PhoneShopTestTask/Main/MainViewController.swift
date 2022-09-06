//
//  MainViewController.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 27.08.2022.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModelProtocol!
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.backgroundColor = .none
        tableview.separatorStyle = .none
        tableview.register(CategoryTableViewCell.self,
                           forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableview.register(HotSalesTableViewCell.self,
                           forCellReuseIdentifier: HotSalesTableViewCell.identifier)
        tableview.register(BestSellerTableViewCell.self,
                           forCellReuseIdentifier: BestSellerTableViewCell.identifier)
        tableview.register(MainHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MainHeaderView.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        //возможно создание кастомного вью
        title = viewModel.title
        
        let image = UIImage(named: "filterIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTouchFilterOptionsButton))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupSubview() {
        view.addSubview(tableView)
        view.backgroundColor = .systemGray6
        
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func didTouchFilterOptionsButton() {
        let configurator = FilterOptionsConfigurator(brands: DataStorage.shared.getBrandsForFilter(),
                                                     prices: DataStorage.shared.getPricesForFilter(),
                                                     sizes: DataStorage.shared.getSizesForFilter()) // данные должны получаться из другого объекта 
        present(configurator.configure(), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
            cell.viewModel = viewModel as? CategoryTableCellViewModelProtocol
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotSalesTableViewCell.identifier, for: indexPath) as! HotSalesTableViewCell
            cell.viewModel = viewModel as? HotSalesTableCellViewModelProtorol
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: BestSellerTableViewCell.identifier, for: indexPath) as! BestSellerTableViewCell
            cell.viewModel = viewModel as? BestSellerTableCellViewModelProtorol
            cell.delegate = self
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return tableView.frame.height / 6
        case 1: return tableView.frame.height / 5
        case 2: return BestSellerTableViewCell.SizesCell.calculateHeightTableCell(countItem: 4, widthTable: tableView.frame.width)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainHeaderView.identifier) as! MainHeaderView
        let enumHeader = Headers(section: section)
        header.set(title: enumHeader.title, textButton: enumHeader.textButton)
        return header
    }
}

extension MainViewController: BestSellerTableViewCellDelegate {
    func showDetailsView(at index: Int) {
        let id = 0 //viewModel.getIdForDevice(at: index)
        let detailsConfigurator = DetailsConfigurator(id: id)
        let vc = detailsConfigurator.configure()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    fileprivate enum Headers: Int {
        case category
        case hotSales
        case bestSeller
        case none
        
        var title: String {
            switch self {
            case .category:
                return "Select Category"
            case .hotSales:
                return "Hot sales"
            case .bestSeller:
                return "Best seller"
            case .none:
                return ""
            }
        }
        
        var textButton: String {
            switch self {
            case .category:
                return "view all"
            case .hotSales:
                return "see more"
            case .bestSeller:
                return "see more"
            case .none:
                return ""
            }
        }
        
        init(section: Int) {
            switch section {
            case 0: self = .category
            case 1: self = .hotSales
            case 2: self = .bestSeller
            default: self = .none
            }
        }
    }
}
