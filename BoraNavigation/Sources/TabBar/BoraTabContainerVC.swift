//
//  BoraTabContainerVC.swift
//  BoraKit
//
//  Created by 신정욱 on 12/3/25.
//

import UIKit

import SnapKit

public class BoraTabContainerVC: UIViewController {
    
    // MARK: Properties
    
    /// 현재 화면에 보여지는 뷰 컨트롤러 (상태 관리용)
    private weak var preVC: UIViewController?
    
    /// 화면 전환 중 여부 (중복 요청 방지용)
    private var isTransitioning = false
    
    // MARK: Transition
    
    /// 주어진 뷰 컨트롤러로 화면 전환
    public func transition(
        to newVC: UIViewController,
        completion: (() -> Void)?
    ) {
        // 동일 뷰 컨트롤러 이동이거나 이미 전환 중이면 요청 무시
        guard preVC !== newVC, !isTransitioning else { return }
        
        // 전환 상태 갱신
        isTransitioning = true
        
        // 1. 새 뷰컨트롤러 추가 및 레이아웃 설정
        addChild(newVC)
        view.addSubview(newVC.view)
        newVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        newVC.didMove(toParent: self)
        
        newVC.view.isUserInteractionEnabled = true
        
        // 2. 이전 뷰컨트롤러가 없는 경우(초기 세팅) 애니메이션 생략
        if preVC == nil {
            preVC = newVC
            isTransitioning = false
            return
        }
        
        // 3. 전환 애니메이션 준비
        preVC?.view.isUserInteractionEnabled = false
        newVC.view.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        newVC.view.alpha = 0
        
        // 4. 전환 애니메이션 실행
        UIView.animate(
            withDuration: 0.16,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            newVC.view.transform = .identity
            newVC.view.alpha = 1
            
        } completion: { [weak self] _ in
            // 5. 이전 뷰컨트롤러 정리
            self?.preVC?.willMove(toParent: nil)
            self?.preVC?.view.removeFromSuperview()
            self?.preVC?.removeFromParent()
            
            // 6. 상태 업데이트 및 완료
            self?.preVC = newVC
            self?.isTransitioning = false
            
            // 7. 완료 핸들러 실행
            completion?()
        }
    }
}
