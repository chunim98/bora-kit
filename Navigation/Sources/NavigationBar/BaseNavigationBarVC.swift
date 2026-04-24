//
//  BaseNavigationBarVC.swift
//  BoraKit
//
//  Created by 신정욱 on 4/24/26.
//

import UIKit

/// 커스텀 네비게이션 바 뷰 컨트롤러
open class BaseNavigationBarVC<NavigationBar: MainNavigationBar>: UIViewController {
    
    // MARK: Properties
    
    /// 네비게이션바와 탭바에 의해 가려지지 않는 실제 컨텐츠 배치 영역
    public let contentLayoutGuide = UILayoutGuide()
    
    // MARK: Components
    
    /// 상단 네비게이션 바
    public let mainNavigationBar = NavigationBar()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네이티브 네비게이션바 항상 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainNavigationBar)
        view.addLayoutGuide(contentLayoutGuide)
        
        mainNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            mainNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainNavigationBar.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: NavigationBar.height
            ),
            
            contentLayoutGuide.topAnchor.constraint(equalTo: mainNavigationBar.bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}
