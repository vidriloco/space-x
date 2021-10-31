//
//  MainViewController.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import UIKit

class MainViewController: UITableViewController {

    private var viewModel: MainViewModel
    private var filterParams = FilterViewModel.SelectionParams()

    public init(with viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewModel.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
}

extension MainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.entries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .launchesSection(items) = viewModel.entries[section] {
            return items.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.entries[indexPath.section] {
        case .companyBioSection(let companyInfo):
            return buildView(for: companyInfo)
        case .launchesSection(let items):
            let launchViewModel = items[indexPath.row]
            return buildView(for: launchViewModel)
        }
    }
}

private extension MainViewController {
    
    struct Identifiers {
        static let companyInfoCell = String(describing: CompanyInfoTableViewCell.self)
        static let launchCell = String(describing: LaunchTableViewCell.self)
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.filterText,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(willDisplayFilterDialog))
    }
    
    func buildView(for launchViewModel: LaunchViewModel) -> UITableViewCell {

        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.launchCell) as? LaunchTableViewCell {
            dequeuedCell.configure(with: launchViewModel)
            return dequeuedCell
        }
        
        return UITableViewCell()
    }
    
    func buildView(for companyDescription: String) -> UITableViewCell {
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.companyInfoCell) as? CompanyInfoTableViewCell {
            dequeuedCell.configure(with: companyDescription)
            return dequeuedCell
        }
        
        return UITableViewCell()
    }
    
    func configureTableView() {
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: Identifiers.launchCell)
        tableView.register(CompanyInfoTableViewCell.self, forCellReuseIdentifier: Identifiers.companyInfoCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    
    @objc func willDisplayFilterDialog() {
        let filterViewModel: FilterViewModel = .init(yearSelectorOptions: Array(2000...2017))
        filterViewModel.selectedParams = filterParams
        let filterViewController = FilterViewController(with: filterViewModel)
        let navigationViewController = UINavigationController(rootViewController: filterViewController)
        navigationViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        
        
        if let sheet = navigationViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.presentedViewController.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)

        }
        present(navigationViewController, animated: true, completion: nil)
    }
}

extension MainViewController : MainViewModelDelegate {
    func shouldReloadTable() {
        tableView.reloadData()
    }
    
    func shouldDisplayError() {
        // Will handle error
    }
}
