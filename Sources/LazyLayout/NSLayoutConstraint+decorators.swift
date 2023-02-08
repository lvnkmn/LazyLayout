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
        isActive = true
        return self
    }
    
    @discardableResult
    func activated() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    @discardableResult
    func deactivated() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    @discardableResult
    func preparedForDisplay() -> NSLayoutConstraint {
        deactivatedAutoResizingMasks().activated()
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
