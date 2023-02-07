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

        @discardableResult
        public func activate(@ArrayBuilder constraints provideConstraints: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
            provideConstraints()
                .map {
                    $0.preparedForDisplay()
                }
        }

        @discardableResult
        public func setHeight(to heightConstant: CGFloat) -> NSLayoutConstraint {
            view.heightAnchor
                .constraint(equalToConstant: heightConstant)
                .preparedForDisplay()
        }

        @discardableResult
        public func setWidth(to widthConstant: CGFloat) -> NSLayoutConstraint {
            view.widthAnchor
                .constraint(equalToConstant: widthConstant)
                .preparedForDisplay()
        }


        @discardableResult
        public func setAspectRatio(to aspectRatio: CGFloat) -> NSLayoutConstraint {
            view.heightAnchor
                .constraint(
                    equalTo: view.widthAnchor,
                    multiplier: aspectRatio
                )
                .preparedForDisplay()
        }
    }
}

public extension UIView.Layout {

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

    func pin(
        toEdges edges: [Edge] = .all,
        of constrainable: LayoutConstrainable,
        withPadding padding: UIEdgeInsets = .zero
    ) {
        edges.forEach { edge in
            pin(toEdge: edge, of: constrainable)?.with(constant: padding.value(forEdge: edge))
        }
    }

    @discardableResult
    func pin(
        toEdge edge: Edge,
        of constrainable: LayoutConstrainable
    ) -> NSLayoutConstraint? {
        if
            let viewXAnchor = view.xAxisAnchors[edge],
            let superViewXAnchor = constrainable.xAxisAnchors[edge] {

            return viewXAnchor.constraint(equalTo: superViewXAnchor)
                .preparedForDisplay()
        }

        if
            let viewXAnchor = view.yAxisAnchors[edge],
            let superViewXAnchor = constrainable.yAxisAnchors[edge] {

            return viewXAnchor.constraint(equalTo: superViewXAnchor)
                .preparedForDisplay()
        }

        return nil
    }
}

// Super view shortcuts
public extension UIView.Layout {

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

    @discardableResult
    func pinToSuperview(
        edges: [Edge] = .all
    ) -> [NSLayoutConstraint] {
        pinToSuperview(edges: edges, withPadding: .zero)
    }

    @discardableResult
    func pinBottomEdgeToSuperView() -> NSLayoutConstraint? {
        pinToSuperView(edge: .bottom)
    }

    @discardableResult
    func pinTopEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .top)
    }

    @discardableResult
    func pinLeftEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .left)
    }

    @discardableResult
    func pinRightEdgeToSuperView(withPadding padding: CGFloat = .zero) -> NSLayoutConstraint? {
        pinToSuperView(edge: .right)
    }

    @discardableResult
    func pinToSuperView(edge: Edge) -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return pin(toEdge: edge, of: superview)?
            .preparedForDisplay()
    }

    @discardableResult
    func centerVerticallyInSuperView() -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return view.centerYAnchor
            .constraint(equalTo: superview.centerYAnchor)
            .preparedForDisplay()
    }
    
    @discardableResult
    func centerHorizontallyInSuperView() -> NSLayoutConstraint? {
        guard let superview = view.superview else { return nil }

        return view.centerXAnchor
            .constraint(equalTo: superview.centerXAnchor)
            .preparedForDisplay()
    }
    
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
