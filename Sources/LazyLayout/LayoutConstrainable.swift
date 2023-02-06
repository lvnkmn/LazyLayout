//
//  File.swift
//  
//
//  Created by Menno Lovink on 25/01/2023.
//

import UIKit

public protocol LayoutConstrainable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutConstrainable {}
extension UILayoutGuide: LayoutConstrainable {}

extension LayoutConstrainable {

    var xAxisAnchors: [UIView.Layout.Edge: NSLayoutXAxisAnchor] {
        [
            .left: leftAnchor,
            .right: rightAnchor
        ]
    }

    var yAxisAnchors: [UIView.Layout.Edge: NSLayoutYAxisAnchor] {
        [
            .top: topAnchor,
            .bottom: bottomAnchor
        ]
    }
}
