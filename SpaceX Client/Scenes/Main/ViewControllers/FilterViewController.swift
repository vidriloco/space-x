//
//  FilterViewController.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import UIKit

class FilterViewController: UIViewController {

    private var viewModel: FilterViewModel
    
    public init(with viewModel: FilterViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var filterByYearLaunchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption2)
        label.text = viewModel.filterByYearLabel
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var yearsPickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = viewModel
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let yearSet = viewModel.indexForSelectedYearOption {
            view.selectRow(yearSet, inComponent: 0, animated: true)
        }
        
        return view
    }()
    
    private lazy var filterByLaunchResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption2)
        label.text = viewModel.filterByLaunchResultLabel
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var launchResultSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.launchResultSelectorOptions?.compactMap { $0.launchTextInSelector })
        
        if let launchResultSet = viewModel.indexForSelectedLaunchResultOption {
            segmentedControl.selectedSegmentIndex = launchResultSet
        }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(viewModel, action: #selector(viewModel.didChangeLaunchResultOption(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var orderingByYearLaunchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption2)
        label.text = viewModel.orderingByYearLabel
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
        
    private lazy var orderingOptionsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.orderingSelectorOptions?.compactMap { $0.optionTextInSelector })
        
        if let orderingOptionSet = viewModel.indexForSelectedOrderingOption {
            segmentedControl.selectedSegmentIndex = orderingOptionSet
        }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(viewModel, action: #selector(viewModel.didChangeOrderingOption(_:)), for: .valueChanged)
        return segmentedControl
    }()
        
    private lazy var formContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filterByLaunchResultLabel,
            launchResultSegmentedControl,
            orderingByYearLaunchLabel,
            orderingOptionsSegmentedControl,
            filterByYearLaunchLabel,
            yearsPickerView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.setCustomSpacing(10, after: orderingByYearLaunchLabel)
        stackView.setCustomSpacing(10, after: filterByLaunchResultLabel)
        stackView.setCustomSpacing(10, after: orderingOptionsSegmentedControl)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(formContainerView)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: -Constants.horizontalMargin),
            view.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: Constants.horizontalMargin),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: -Constants.verticalMargin),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: Constants.verticalMargin),
            orderingOptionsSegmentedControl.heightAnchor.constraint(equalToConstant: Constants.spacingAfterLabels),
            launchResultSegmentedControl.heightAnchor.constraint(equalToConstant: Constants.spacingAfterLabels),
            yearsPickerView.heightAnchor.constraint(equalToConstant: Constants.yearsPickerHeight)
        ])
        
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.saveButtonText,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(save))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.discardButtonText,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(close))
    }
    
    @objc private func save() {
        print(viewModel.selectedParams)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func close() {
        viewModel.selectedParams.resetSelection()
        dismiss(animated: true, completion: nil)
    }
    
    struct Constants {
        static let yearsPickerHeight: CGFloat = 100
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 20
        static let spacingAfterLabels: CGFloat = 30
    }
}

extension FilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.yearSelectorOptionsWithDefaultOption.count
    }
}
