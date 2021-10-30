//
//  NSMutableString.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 30/10/2021.
//

import UIKit

extension NSMutableAttributedString {
    
    var fontSize: CGFloat { 15 }
    
    var boldFont: UIFont { UIFont.boldSystemFont(ofSize: fontSize) }
    
    var normalFont: UIFont { UIFont.systemFont(ofSize: fontSize) }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
