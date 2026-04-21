//
//  TabBarCompatible.swift
//  BoraKit
//
//  Created by 신정욱 on 4/21/26.
//

import UIKit
import Combine

public protocol TabBarCompatible: UIView {
    
    // MARK: Properties
    
    /// 탭바의 고정 높이
    static var height: CGFloat { get }
    
    // MARK: Life Cycle
    
    init(items: [UITabBarItem])
    
    // MARK: Public Methods
    
    /// 주어진 인덱스로 버튼 상태 업데이트
    func updateUI(_ index: Int)
    
    /// 탭바의 표시/숨김 상태를 애니메이션과 함께 갱신
    func setVisible(_ visible: Bool)
    
    // MARK: Combine Interface
    
    /// 선택한 탭 인덱스 퍼블리셔
    var selectedTabIndexPublisher: AnyPublisher<Int, Never> { get }
}

// MARK: Default Implementation

extension TabBarCompatible {
    /// 탭바의 표시/숨김 상태를 애니메이션과 함께 갱신
    public func setVisible(_ visible: Bool) {
        // 숨김 상태일 경우, 사용자 터치를 막아서 오작동을 방지
        isUserInteractionEnabled = visible
        
        // 슬라이드(transform) 및 페이드(alpha) 애니메이션 적용
        UIView.animate(
            withDuration: 0.32,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
        ) { [weak self] in
            guard let self else { return }
            transform = visible
            ? CGAffineTransform.identity
            : CGAffineTransform(translationX: 0, y: Self.height)
            alpha = visible ? 1 : 0
        }
    }
}
