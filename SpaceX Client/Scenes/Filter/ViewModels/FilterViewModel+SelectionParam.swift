//
//  SelectionParam.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import Foundation

extension FilterViewModel {
    
    class SelectionParams {
        var orderingOption: OrderingOption = .unordered
        var launchResultOption: LaunchResultOption = .all
        var year: Int? = nil
        
        init() { }
        
        func resetSelection() {
            orderingOption = .unordered
            launchResultOption = .all
            year = nil
        }
    }
}
