//
//  FilterViewModel.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import Foundation

import Foundation
import UIKit

final class FilterViewModel: NSObject {
    
    enum LaunchResultOption {
        case success
        case failure
        case all
    }
    
    enum OrderingOption: String {
        case ascending
        case descending
        case unordered
    }
    
    let title: String?
    let saveButtonText: String?
    let discardButtonText: String?
    
    let filterByYearLabel: String?
    let filterByLaunchResultLabel: String?
    let orderingByYearLabel: String?
    
    let yearSelectorOptions: [Int]?
    let launchResultSelectorOptions: [LaunchResultOption]?
    let orderingSelectorOptions: [OrderingOption]?
    
    var selectedParams = SelectionParams()
    
    var yearSelectorOptionsWithDefaultOption: [String] {
        guard let yearOptions = yearSelectorOptions else { return [] }
        return [" "] + yearOptions.map { "\($0)" }
    }
    
    init(title: String? = "Filter Settings",
         saveButtonText: String? = "Save",
         discardButtonText: String? = "Dismiss",
         filterByYearLabel: String? = "Show launches done in the following year: ",
         filterByLaunchResultLabel: String? =  "Show launches with result: ",
         orderingByYearLabel: String? = "Order launches by year: ",
         yearSelectorOptions: [Int]? = [2000],
         launchResultSelectorOptions: [LaunchResultOption]? = [.all, .failure, .success],
         orderingSelectorOptions: [OrderingOption]? = [.unordered, .ascending, .descending]) {
        self.title = title
        self.saveButtonText = saveButtonText
        self.discardButtonText = discardButtonText
        
        self.filterByYearLabel = filterByYearLabel
        self.filterByLaunchResultLabel = filterByLaunchResultLabel
        self.orderingByYearLabel = orderingByYearLabel
        self.yearSelectorOptions = yearSelectorOptions
        self.launchResultSelectorOptions = launchResultSelectorOptions
        self.orderingSelectorOptions = orderingSelectorOptions
    }
    
    var indexForSelectedYearOption: Int? {
        guard let year = selectedParams.year else { return nil }
        return yearSelectorOptionsWithDefaultOption.firstIndex(of: "\(year)")
    }
    
    var indexForSelectedOrderingOption: Int? {
        orderingSelectorOptions?.firstIndex(of: selectedParams.orderingOption)
    }
    
    var indexForSelectedLaunchResultOption: Int? {
        launchResultSelectorOptions?.firstIndex(of: selectedParams.launchResultOption)
    }
}

@objc extension FilterViewModel {
    func didChangeOrderingOption(_ sender: UISegmentedControl) {
        selectedParams.orderingOption = orderingSelectorOptions?[sender.selectedSegmentIndex] ?? .unordered
        
    }
    
    func didChangeLaunchResultOption(_ sender: UISegmentedControl) {
        selectedParams.launchResultOption = launchResultSelectorOptions?[sender.selectedSegmentIndex] ?? .all
    }
}

extension FilterViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        yearSelectorOptionsWithDefaultOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedParams.year = Int(yearSelectorOptionsWithDefaultOption[row])
    }
}

extension FilterViewModel.OrderingOption {
    var optionTextInSelector: String {
        switch self {
        case .ascending: return "Ascending"
        case .descending: return "Descending"
        case .unordered: return "None"
        }
    }
}

extension FilterViewModel.LaunchResultOption {
    var launchTextInSelector: String {
        switch self {
        case .success: return "Success"
        case .failure: return "Failure"
        case .all: return "All"
        }
    }
}

extension FilterViewModel.LaunchResultOption {
    var apiString: String? {
        switch self {
        case .success: return "true"
        case .failure: return "false"
        case .all: return nil
        }
    }
}

extension FilterViewModel.OrderingOption {
    var apiString: String? {
        switch self {
        case .ascending: return "asc"
        case .descending: return "desc"
        case .unordered: return nil
        }
    }
}
