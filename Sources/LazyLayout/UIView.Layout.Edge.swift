//
//  File.swift
//  
//
//  Created by Menno Lovink on 25/01/2023.
//

import UIKit

public extension UIView.Layout {

    enum Edge: Equatable {
        case top, right, bottom, left
    }
}

extension UIView.Layout.Edge {
    
    func attribute(shouldConsiderMargin: Bool) -> NSLayoutConstraint.Attribute {
        switch self {
        case .top:
            return shouldConsiderMargin ? .topMargin : .top
        case .right:
            return shouldConsiderMargin ? .rightMargin : .right
        case .bottom:
            return shouldConsiderMargin ? .bottomMargin : .bottom
        case .left:
            return shouldConsiderMargin ? .leftMargin : .left
        }
    }
}

extension UIView.Layout.Edge {

    var axis: NSLayoutConstraint.Axis {
        switch self {
        case .top:
            return .vertical
        case .right:
            return .horizontal
        case .bottom:
            return .vertical
        case .left:
            return .horizontal
        }
    }
}

public extension Array where Element == UIView.Layout.Edge {

    static var all: [UIView.Layout.Edge] {
        [.left, .top, .right, .bottom]
    }

    static var horizontal: [UIView.Layout.Edge] {
        [.left, .right]
    }

    static var vertical: [UIView.Layout.Edge] {
        [.top, .bottom]
    }

    static var topLeft: [UIView.Layout.Edge] {
        [.top, .left]
    }

    static var topRight: [UIView.Layout.Edge] {
        [.top, .right]
    }

    static var bottomRight: [UIView.Layout.Edge] {
        [.bottom, .right]
    }

    static var bottomLeft: [UIView.Layout.Edge] {
        [.bottom, .left]
    }

    func except(_ edge: Element) -> [UIView.Layout.Edge] {
        filter { $0 != edge }
    }
}
