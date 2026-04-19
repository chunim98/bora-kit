//
//  AttributedLabel.swift
//  BoraScaffold
//
//  Created by 신정욱 on 3/16/26.
//

import UIKit

/// 기본 텍스트 스타일을 적용하는 UILabel
open class AttributedLabel: UILabel {
    
    // MARK: Properties
    
    /// 기본 텍스트 속성
    /// - 값이 변경되면 현재 텍스트에 다시 적용됨
    open var defaultTextAttributes: [NSAttributedString.Key: Any]? {
        didSet { updateAttributedText(with: text) }
    }
    
    /// 일반 텍스트를 설정하면 기본 속성을 적용해 attributedText로 변환
    open override var text: String? {
        get { attributedText?.string }
        set { updateAttributedText(with: newValue) }
    }
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Private Helpers
    
    /// 문자열에 기본 텍스트 속성을 적용해 attributedText 갱신
    private func updateAttributedText(with text: String?) {
        attributedText = text.map {
            NSAttributedString(string: $0, attributes: defaultTextAttributes)
        }
    }
}
