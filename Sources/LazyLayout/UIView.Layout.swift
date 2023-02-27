//
//  UIView+layout.swift
//  MidiJ
//
//  Created by me on 16/01/2023.
//

import UIKit
import SourceSeeds

public extension UIView {

    var layout: Layout {
        .init(view: self)
    }

    struct Layout {

        let view: UIView
    }
}

public extension UIView.Layout {

    @discardableResult
    func activate(@ArrayBuilder constraints provideConstraints: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        provideConstraints()
            .map {
                $0.preparedForDisplay()
            }
    }

    @discardableResult
    func setHeight(to heightConstant: CGFloat) -> NSLayoutConstraint {
        view.heightAnchor
            .constraint(equalToConstant: heightConstant)
            .preparedForDisplay()
    }

    @discardableResult
    func setWidth(to widthConstant: CGFloat) -> NSLayoutConstraint {
        view.widthAnchor
            .constraint(equalToConstant: widthConstant)
            .preparedForDisplay()
    }


    @discardableResult
    func setAspectRatio(to aspectRatio: CGFloat) -> NSLayoutConstraint {
        view.heightAnchor
            .constraint(
                equalTo: view.widthAnchor,
                multiplier: aspectRatio
            )
            .preparedForDisplay()
    }
    
    @discardableResult
    func toLeftOf(_ constrainable: LayoutConstrainable) -> NSLayoutConstraint {
        view.rightAnchor.constraint(equalTo: constrainable.leftAnchor)
            .preparedForDisplay()
    }

    @discardableResult
    func toRightOf(_ constrainable: LayoutConstrainable) -> NSLayoutConstraint {
        view.leftAnchor.constraint(equalTo: constrainable.rightAnchor)
            .preparedForDisplay()
    }

    @discardableResult
    func above(_ constrainable: LayoutConstrainable) -> NSLayoutConstraint {
        view.bottomAnchor.constraint(equalTo: constrainable.topAnchor)
            .preparedForDisplay()
    }

    @discardableResult
    func below(_ constrainable: LayoutConstrainable) -> NSLayoutConstraint {
        view.topAnchor.constraint(equalTo: constrainable.bottomAnchor)
            .preparedForDisplay()
    }

    /// Pin
    /// - Parameters:
    ///   - edge: edges to pin to
    ///   - constrainable: constrainable to pin to, when providing nil, the superView will be used, when that doesn't exist, pin will fail
    /// - Returns: NSLayoutConstraint
    @discardableResult
    func pin(
        toEdge edge: Edge,
        of constrainable: LayoutConstrainable? = nil
    ) -> NSLayoutConstraint? {
        guard let constrainable = constrainable ?? view.superview else { return nil }
        if
            let viewXAnchor = view.xAxisAnchors[edge],
            let constrainableXAsisAnchor = constrainable.xAxisAnchors[edge] {

            return viewXAnchor.constraint(equalTo: constrainableXAsisAnchor)
                .preparedForDisplay()
        }

        if
            let viewYAnchor = view.yAxisAnchors[edge],
            let constrainableYAxisAnchor = constrainable.yAxisAnchors[edge] {

            return viewYAnchor.constraint(equalTo: constrainableYAxisAnchor)
                .preparedForDisplay()
        }

        return nil
    }
    
    @discardableResult
    func pin(
        toEdges edges: [Edge] = .all,
        of constrainable: LayoutConstrainable? = nil,
        withPadding padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        (constrainable ?? view.superview)
            .map { constrainable in
                edges.compactMap { edge in
                    pin(toEdge: edge, of: constrainable)?
                        .with(constant: padding.value(forEdge: edge))
                }
        } ?? []
    }
    
    @discardableResult
    func centerVertically(in constrainable: LayoutConstrainable? = nil) -> NSLayoutConstraint? {
        (constrainable ?? view.superview)
            .map { constrainable in
                view.centerYAnchor
                    .constraint(equalTo: constrainable.centerYAnchor)
                    .preparedForDisplay()
            }
    }

    @discardableResult
    func centerHorizontally(in constrainable: LayoutConstrainable? = nil) -> NSLayoutConstraint? {
        (constrainable ?? view.superview)
            .map { constrainable in
                view.centerXAnchor
                    .constraint(equalTo: constrainable.centerXAnchor)
                    .preparedForDisplay()
            }
    }
    
    @discardableResult
    func center(in constrainable: LayoutConstrainable? = nil) -> [NSLayoutConstraint] {
        [
            centerHorizontally(in: constrainable),
            centerVertically(in: constrainable)
        ]
            .compactMap {
                $0
            }
    }
}

private extension UIEdgeInsets {

    func value(forEdge edge: UIView.Layout.Edge) -> CGFloat {
        switch edge {
        case .top:
            return top
        case .right:
            return right
        case .bottom:
            return bottom
        case .left:
            return left
        }
    }
}

// Deprications
extension UIView.Layout {
    @available(*, deprecated, renamed: "pin(toEdges:of:withPadding:)")
    func pin(
        toEdges edges: [Edge] = .all,
        of constrainable: LayoutConstrainable,
        withPadding padding: UIEdgeInsets = .zero
    ) {
        edges.forEach { edge in
            pin(toEdge: edge, of: constrainable)?.with(constant: padding.value(forEdge: edge))
        }
    }
    
    @available(*, deprecated, renamed: "pin(toEdges:of:withPadding:)")
    @discardableResult
    func pinToSuperview(
        edges: [Edge] = .all,
        withPadding padding: UIEdgeInsets
    ) -> [NSLayoutConstraint] {
        edges.compactMap { edge in
            pinToSuperView(edge: edge)?
                .with(constant: padding.value(forEdge: edge))
        }
    }
    
    @available(*, deprecated, renamed: "pin(toEdges:of:withPadding:)")
    @discardableResult
    func pinToSuperview(
        edges: [Edge] = .all
    ) -> [NSLayoutConstraint] {
        pin(toEdges: edges)
    }
    
    @available(*, deprecated, renamed: "pin(toEdge:of:)")
    @discardableResult
    func pinToSuperView(edge: Edge) -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return pin(toEdge: edge, of: superview)?
            .preparedForDisplay()
    }
    
    @available(*, deprecated, renamed: "pin(toEdge:of:)")
    @discardableResult
    func pinBottomEdgeToSuperView() -> NSLayoutConstraint? {
        pinToSuperView(edge: .bottom)
    }

    @available(*, deprecated, renamed: "pin(toEdge:of:)")
    @discardableResult
    func pinTopEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .top)
    }

    @available(*, deprecated, renamed: "pin(toEdge:of:)")
    @discardableResult
    func pinLeftEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .left)
    }

    @available(*, deprecated, renamed: "pin(toEdge:of:)")
    @discardableResult
    func pinRightEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .right)
    }
    
    @available(*, deprecated, renamed: "centerVertically(in:)")
    @discardableResult
    func centerVerticallyInSuperView() -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return view.centerYAnchor
            .constraint(equalTo: superview.centerYAnchor)
            .preparedForDisplay()
    }
    
    @available(*, deprecated, renamed: "centerHorizontally(in:)")
    @discardableResult
    func centerHorizontallyInSuperView() -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return view.centerXAnchor
            .constraint(equalTo: superview.centerXAnchor)
            .preparedForDisplay()
    }
    
    @available(*, deprecated, renamed: "center(in:)")
    @discardableResult
    func centerInSuperView() -> [NSLayoutConstraint] {
        [
            centerHorizontallyInSuperView(),
            centerVerticallyInSuperView()
        ]
            .compactMap {
                $0
            }
    }
}
