//
//  File.swift
//  
//
//  Created by Menno Lovink on 25/01/2023.
//

import UIKit

public extension NSLayoutConstraint {

    @discardableResult
    func with(constant: CGFloat) -> NSLayoutConstraint {
        self.constant = constant
        return self
    }

    @discardableResult
    func with(multiplier: CGFloat) -> NSLayoutConstraint {
        deactivated()
            .map {
                NSLayoutConstraint(
                    item: $0.firstItem as Any ,
                    attribute: $0.firstAttribute,
                    relatedBy: $0.relation,
                    toItem: $0.secondItem,
                    attribute: $0.secondAttribute,
                    multiplier: multiplier,
                    constant: $0.constant
                )
            }
            .setting(priority: priority)
            .setting(identifier: identifier)
            .setting(shouldBeArchived: shouldBeArchived)
            .activated()
    }
    
    @discardableResult
    func with(relation: Relation) -> NSLayoutConstraint {
        archived()
        return .init(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        .activated()
    }

    @discardableResult
    func archived() -> NSLayoutConstraint {
        shouldBeArchived = true
        deactivated()
        return self
    }
    
    @discardableResult
    func activated() -> NSLayoutConstraint {
        NSLayoutConstraint.activate([self])
        return self
    }

    @discardableResult
    func deactivated() -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        return self
    }

    @discardableResult
    func preparedForDisplay() -> NSLayoutConstraint {
        deactivatedAutoResizingMasks().activated()
    }
    
    @discardableResult
    func setting(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    @discardableResult
    func setting(shouldBeArchived: Bool) -> NSLayoutConstraint {
        self.shouldBeArchived = shouldBeArchived
        return self
    }
    
    @discardableResult
    func setting(identifier: String?) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
}

extension NSLayoutConstraint {

    @discardableResult
    func deactivatedAutoResizingMasks() -> NSLayoutConstraint {
        if let firstView = firstItem as? UIView {
            firstView.translatesAutoresizingMaskIntoConstraints = false

            if
                let secondView = secondItem as? UIView,
                secondView !== firstView.superview { // Parent view may still rely on autoResizingMask

                secondView.translatesAutoresizingMaskIntoConstraints = false
            }
        }

        return self
    }
}
