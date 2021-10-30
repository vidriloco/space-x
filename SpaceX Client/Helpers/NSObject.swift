//
//  NSObject.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 29/10/2021.
//

import Foundation

public protocol Chainable {}
extension Chainable {
    @discardableResult public func with(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var value = self
        try block(&value)
        return value
    }
}

extension NSObject: Chainable {}

