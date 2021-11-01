//
//  MainViewController.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import UIKit
import MBProgressHUD

// MARK: - MainViewControllerDelegate

protocol MainViewControllerDelegate: AnyObject {
    func willShowFilterOptions(from controller: UIViewController)
    func willShowLinkChooserAlert(wikipediaURL: String?, youtubeURL: String?, youtubeIdURL: String?, articleURL: String?)
}

// MARK: - MainViewController (Base class)

class MainViewController: UITableViewController {

    private var viewModel: MainViewModel
    
    weak var delegate: MainViewControllerDelegate?
    
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

// MARK: - MainViewController (TableView methods)

extension MainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if !viewModel.sections.isEmpty {
            configureNavigationBar()
        }
        
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if case let .launchesSection(items) = viewModel.sections[section] {
            return items.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.sections[indexPath.section] {
        case .companyBioSection(let companyInfo):
            return buildView(for: companyInfo)
        case .launchesSection(let items):
            let launchViewModel = items[indexPath.row]
            return buildView(for: launchViewModel)
        case .emptyLaunchesSection:
            return buildEmptyView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .emptyLaunchesSection = viewModel.sections[indexPath.section] {
            return Constants.emptyResultsTableViewCellHeight
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .launchesSection(items) = viewModel.sections[indexPath.section] {
            let launch = items[indexPath.row]
            delegate?.willShowLinkChooserAlert(wikipediaURL: launch.wikipediaURL,
                                               youtubeURL: launch.videoURL,
                                               youtubeIdURL: launch.youtubeIdURL,
                                               articleURL: launch.articleURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch viewModel.sections[indexPath.section] {
        case .emptyLaunchesSection, .companyBioSection:
            return nil
        case .launchesSection:
            return indexPath
        }
    }
    
    struct Identifiers {
        static let companyInfoCell = String(describing: CompanyInfoTableViewCell.self)
        static let launchCell = String(describing: LaunchTableViewCell.self)
        static let emptyLaunchListCell = String(describing: EmptyResultsTableViewCell.self)
    }
}

// MARK: - MainViewController (View configuration private methods)

private extension MainViewController {
    
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
    
    func buildEmptyView() -> UITableViewCell {
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.emptyLaunchListCell) as? EmptyResultsTableViewCell {
            dequeuedCell.configure()
            return dequeuedCell
        }
        
        return UITableViewCell()
    }
    
    func configureTableView() {
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: Identifiers.launchCell)
        tableView.register(CompanyInfoTableViewCell.self, forCellReuseIdentifier: Identifiers.companyInfoCell)
        tableView.register(EmptyResultsTableViewCell.self, forCellReuseIdentifier: Identifiers.emptyLaunchListCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
    
    @objc func willDisplayFilterDialog() {
        delegate?.willShowFilterOptions(from: self)
    }
}

// MARK: - MainViewController (MainViewModelDelegate conformance)

extension MainViewController : MainViewModelDelegate {
    func willReloadTable() {
        tableView.backgroundView = nil
        tableView.reloadData()
    }
    
    func willDisplayError() {
        let edgeCaseView = EdgeCaseListView(with: "Our apologies",
                                            message: "We could not retrieve the stuff we wanted to show you",
                                            iconName: "error-icon",
                                            buttonText: "Retry" )
        edgeCaseView.delegate = self
        tableView.backgroundView = edgeCaseView
        navigationItem.rightBarButtonItem = nil
        tableView.reloadData()
    }
    
    func displayLoadingIndicator() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARK: - MainViewController (EdgeCaseListViewDelegate conformance)

extension MainViewController: EdgeCaseListViewDelegate {
    func didTapActionButton() {
        viewModel.viewNeedsUpdate()
    }
}

// MARK: - MainViewController (Constants)

extension MainViewController {
    struct Constants {
        static let emptyResultsTableViewCellHeight: CGFloat = 300
        static let estimatedRowHeight: CGFloat = 100
    }
}
