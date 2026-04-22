//
//  BoraTabBarVC.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit
import Combine

import SnapKit

open class BoraTabBarVC<TabBar: BoraTabBarCompatible>:
    UITabBarController,
    BoraTabBarVCCompatible
{
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 시스템 TabBar의 제약을 피하고 자유로운 애니메이션 구현을 위해 커스텀 객체 사용
    public let mainTabBar: any BoraTabBarCompatible = TabBar()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션바 및 탭바 항상 숨기기
        navigationController?.navigationBar.isHidden = true
        tabBar.isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainTabBar)
        
        mainTabBar.snp.makeConstraints {
            // 하단 Safe Area 영역까지 포함하여 배경색이 채워지도록 설정
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(TabBar.height)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 현재 탭 인덱스로 탭바 UI 갱신
        publisher(for: \.selectedIndex)
            .sink { [weak self] in self?.mainTabBar.updateUI($0) }
            .store(in: &cancellables)
        
        // 선택한 탭 인덱스 상태를 갱신
        mainTabBar.selectedIndexPublisher
            .sink { [weak self] in self?.selectedIndex = $0 }
            .store(in: &cancellables)
    }
    
    // MARK: Public Methods
    
    open override func setViewControllers(
        _ viewControllers: [UIViewController]?,
        animated: Bool
    ) {
        super.setViewControllers(viewControllers, animated: animated)
        mainTabBar.setItems(viewControllers?.map(\.tabBarItem))
    }
}
