//
//  AttributedButton.swift
//  BoraKit
//
//  Created by 신정욱 on 3/30/26.
//

import UIKit

open class AttributedButton: UIButton {
    
    // MARK: Properties
    
    /// 기본 타이틀 속성
    open var defaultTitleAttributes: AttributeContainer? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    /// 일반 텍스트를 설정하면 기본 속성을 적용해 attributedTitle로 변환
    open var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        if configuration == nil { configuration = .plain() }
    }
    
    // MARK: Overrides
    
    open override func updateConfiguration() {
        super.updateConfiguration()
        guard var configuration else { return }
        
        if let title {
            configuration.attributedTitle = AttributedString(
                title, attributes: defaultTitleAttributes ?? .init()
            )
            
        } else {
            // title이 nil일 경우 기존 텍스트 초기화
            configuration.attributedTitle = nil
            configuration.title = nil
        }
        
        self.configuration = configuration
    }
}
