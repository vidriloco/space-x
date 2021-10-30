//
//  MainViewController.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import UIKit

class MainViewController: UITableViewController {

    private var viewModel: MainViewModel
    
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
            let launch = items[indexPath.row]
            return buildView(for: launch)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

private extension MainViewController {
    
    struct Identifiers {
        static let companyInfoCell = String(describing: CompanyInfoTableViewCell.self)
        static let launchCell = String(describing: CompanyInfoTableViewCell.self)
    }
    
    func buildView(for launch: Launch) -> UITableViewCell {

        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.launchCell) {
            dequeuedCell.textLabel?.text = launch.name
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.launchCell)
        tableView.register(CompanyInfoTableViewCell.self, forCellReuseIdentifier: Identifiers.companyInfoCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
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
