//
//  InsetAttributedLabel.swift
//  BoraKit
//
//  Created by 신정욱 on 3/16/26.
//

import UIKit

open class InsetAttributedLabel: AttributedLabel {
    
    // MARK: Properties
    
    /// 레이블 바깥 여백
    open var inset: UIEdgeInsets = .zero {
        didSet { setNeedsLayout() }
    }
    
    // MARK: Overrides
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += inset.top + inset.bottom
        contentSize.width += inset.left + inset.right
        return contentSize
    }
}
