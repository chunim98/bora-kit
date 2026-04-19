//
//  ToggleAttributedButton.swift
//  BoraScaffold
//
//  Created by 신정욱 on 3/25/26.
//

import UIKit

/// 선택 상태 별 스타일을 지정할 수 있는 버튼
/// - Note: 상태는 외부에서 관리해줄 것을 권장
open class ToggleAttributedButton: AttributedButton {
    
    // MARK: Properties
    
    /// 기본 이미지
    open var defaultImage: UIImage? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    /// 선택됨 이미지
    open var selectedImage: UIImage? {
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
        // 기본 외형 설정
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.contentInsets = .zero
        config.imagePadding = 12
        configuration = config
    }
    
    // MARK: Overrides
    
    open override func updateConfiguration() {
        super.updateConfiguration()
        guard var configuration else { return }
        
        // 상태에 따라 맞는 이미지 적용
        configuration.image = isSelected ? selectedImage : defaultImage
        
        self.configuration = configuration
    }
}
