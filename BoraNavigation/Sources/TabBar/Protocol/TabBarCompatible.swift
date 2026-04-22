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
    
    /// 전환 취소 시 복구 기준이 되는 마지막 확정 숨김 상태
    var currentHidden: Bool { get set }
    
    // MARK: Public Methods
    
    /// 주어진 탭바 아이템으로 버튼 구성
    func setItems(_ items: [UITabBarItem]?)
    
    /// 주어진 인덱스로 버튼 상태 업데이트
    func updateUI(_ index: Int)
    
    /// 탭바의 숨김 상태를 갱신
    func setHidden(
        _ hidden: Bool,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    )
    
    // MARK: Publishers
    
    /// 선택한 탭 인덱스 퍼블리셔
    var selectedIndexPublisher: AnyPublisher<Int, Never> { get }
}

// MARK: Default Implementation

extension TabBarCompatible {
    /// 탭바의 숨김 상태를 갱신
    public func setHidden(
        _ hidden: Bool,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    ) {
        // 1. 네비게이션 전환이 아니면 현재 요청 상태를 즉시 확정
        guard let transitionCoordinator else {
            transform = hidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            alpha = hidden ? 0 : 1
            
            isUserInteractionEnabled = !hidden
            currentHidden = hidden
            return
        }
        
        // 2. 전환 중에는 터치를 막고, 네비게이션 애니메이션 타이밍에 맞춰 외형만 변경
        isUserInteractionEnabled = false
        
        transitionCoordinator.animate { [weak self] _ in
            self?.transform = hidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            self?.alpha = hidden ? 0 : 1
            
        } completion: { [weak self] context in
            guard let self else { return }
            
            // 3. 전환 취소 여부에 따라 최종 상태를 확정하고, 터치 가능 여부까지 보정
            let finalHidden = context.isCancelled ? currentHidden : hidden
            
            transform = finalHidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            alpha = finalHidden ? 0 : 1
            
            isUserInteractionEnabled = !finalHidden
            currentHidden = finalHidden
        }
    }
}
