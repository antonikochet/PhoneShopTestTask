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
    
    private let tabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarView.layer.cornerRadius = tabBarView.frame.height / 2
        tabBarView.clipsToBounds = true
    }
    
    private func setupNavigationItem() {
        
        let titleView = MainTitleNavigationBarView()
        guard let frame = navigationController?.navigationBar.frame else { return }
        titleView.frame = CGRect(x: frame.width * (1 - 0.45) / 2,
                                 y: 0,
                                 width: frame.width * 0.45,
                                 height: frame.height)
        titleView.set(location: viewModel.title)
        navigationItem.titleView = titleView
        
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
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tabBarView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: tabBarView.topAnchor,
                         trailing: view.trailingAnchor)
        
        tabBarView.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.bottomAnchor,
                          trailing: view.trailingAnchor)
        tabBarView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        let stackView = UIStackView()
        tabBarView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.contentMode = .scaleAspectFit
        stackView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
       
        var configurator = UIButton.Configuration.plain()
        configurator.imagePadding = 5
        configurator.image = UIImage(named: "point")
        configurator.title = "Explorer"
        configurator.baseForegroundColor = .white
        let explorerButton = UIButton(configuration: configurator)
        stackView.addArrangedSubview(explorerButton)
        explorerButton.heightAnchor.constraint(equalTo: tabBarView.heightAnchor).isActive = true
        explorerButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/3).isActive = true
        
        let bagButton = UIButton()
        bagButton.tintColor = .white
        bagButton.setImage(UIImage(named: "bag"), for: .normal)
        stackView.addArrangedSubview(bagButton)
        bagButton.heightAnchor.constraint(equalTo: tabBarView.heightAnchor).isActive = true
        bagButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 2/9).isActive = true
        bagButton.addTarget(self, action: #selector(didTouchshowCart), for: .touchUpInside)
        
        let favoriteButton = UIButton()
        favoriteButton.tintColor = .white
        favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        stackView.addArrangedSubview(favoriteButton)
        favoriteButton.heightAnchor.constraint(equalTo: tabBarView.heightAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 2/9).isActive = true
        
        let personButton = UIButton()
        personButton.tintColor = .white
        personButton.setImage(UIImage(systemName: "person"), for: .normal)
        stackView.addArrangedSubview(personButton)
        personButton.heightAnchor.constraint(equalTo: tabBarView.heightAnchor).isActive = true
        personButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 2/9).isActive = true
    }
    
    @objc private func didTouchFilterOptionsButton() {
        let filterConfiguratorData = viewModel.getParametrsForFilterOptions()
        let filterConfigurator = FilterOptionsConfigurator(data: filterConfiguratorData)
        let vc = filterConfigurator.configure()
        present(vc, animated: true)
    }
    
    @objc private func didTouchshowCart() {
        let cartConfigurator = CartConfigurator()
        let vc = cartConfigurator.configure()
        navigationController?.pushViewController(vc, animated: true)
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
        case 0: return tableView.frame.height / 5
        case 1: return tableView.frame.height / 4
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
