//
//  UIEdgeInsets+.swift
//  StackLayout
//
//  Created by 신정욱 on 11/14/25.
//

import UIKit

extension UIEdgeInsets {
    public static func + (
        lhs: UIEdgeInsets,
        rhs: UIEdgeInsets
    ) -> UIEdgeInsets {
        self.init(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    public init(
        top: CGFloat = .zero,
        left: CGFloat = .zero,
        bottom: CGFloat = .zero,
        right: CGFloat = .zero,
        _: AnyObject? = nil
    ) {
        self.init(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
    
    public init(
        horizontal: CGFloat = .zero,
        vertical: CGFloat = .zero
    ) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
    
    public init(edges: CGFloat) {
        self.init(
            top: edges,
            left: edges,
            bottom: edges,
            right: edges
        )
    }
}
