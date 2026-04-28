//
//  BaseNavigationBarVC.swift
//  Navigation
//
//  Created by 신정욱 on 4/24/26.
//

import UIKit

/// 커스텀 네비게이션 바 뷰 컨트롤러
open class BaseNavigationBarVC<NavigationBar: NavigationBarType>: UIViewController {
    
    // MARK: Properties
    
    /// 네비게이션바와 탭바에 의해 가려지지 않는 실제 컨텐츠 배치 영역
    public let contentLayoutGuide = UILayoutGuide()
    
    // MARK: Components
    
    /// 상단 네비게이션 바
    public let defaultNavigationBar = NavigationBar()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(defaultNavigationBar)
        view.addLayoutGuide(contentLayoutGuide)
        
        defaultNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            defaultNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            defaultNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultNavigationBar.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: NavigationBar.height
            ),
            
            contentLayoutGuide.topAnchor.constraint(equalTo: defaultNavigationBar.bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}
