//
//  HighlightAttributedButton.swift
//  BoraScaffold
//
//  Created by 신정욱 on 3/30/26.
//

import UIKit

/// 하이라이트 관련 UIKit 이벤트를 effect에 전달하는 버튼
open class HighlightAttributedButton: AttributedButton {
    
    // MARK: Properties
    
    open var highlightEffect: ButtonHighlightEffect?
    
    // MARK: Overrides
    
    open override var isHighlighted: Bool {
        didSet {
            highlightEffect?.highlightDidChange(to: isHighlighted, on: self)
        }
    }
    
    open override func beginTracking(
        _ touch: UITouch,
        with event: UIEvent?
    ) -> Bool {
        highlightEffect?.trackingDidBegin(on: self)
        return super.beginTracking(touch, with: event)
    }
    
    open override func endTracking(
        _ touch: UITouch?,
        with event: UIEvent?
    ) {
        super.endTracking(touch, with: event)
        highlightEffect?.trackingDidEnd(on: self)
    }
    
    open override func cancelTracking(
        with event: UIEvent?
    ) {
        super.cancelTracking(with: event)
        highlightEffect?.trackingDidCancel(on: self)
    }
}
