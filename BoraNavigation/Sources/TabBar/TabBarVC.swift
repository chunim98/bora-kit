//
//  TabBarVC.swift
//  BoraKit
//
//  Created by 신정욱 on 4/21/26.
//

import UIKit
import Combine

import SnapKit

import BoraEssentials

class TabBarVC<TabBar: TabBarCompatible>: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 현재 탭 인덱스
    @Published var currentTabIndex = 0
    
    // MARK: Components
    
    /// 각 탭을 구성하는 뷰 컨트롤러 배열
    private let viewControllers: [UIViewController]
    
    /// 각 탭의 컨텐츠가 담기는 뷰 컨트롤러
    private let tabContainerVC = TabContainerVC()
    
    /// 하단 탭 바
    private let tabBar: TabBar
    
    // MARK: Life Cycle
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        self.tabBar = TabBar(items: viewControllers.map(\.tabBarItem))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(tabContainerVC)
        
        view.addSubview(tabContainerVC.view)
        view.addSubview(tabBar)
        
        tabContainerVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tabBar.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(TabBar.height)
        }
        
        tabContainerVC.didMove(toParent: self)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 주어진 탭 인덱스로 화면 전환 및 탭 바 UI 갱신
        $currentTabIndex
            .sink { [weak self] index in
                guard let nextVC = self?.viewControllers[safe: index]
                else { return }
                
                self?.tabContainerVC.transition(to: nextVC) {
                    self?.tabBar.updateUI(index)
                }
            }
            .store(in: &cancellables)
        
        // 선택한 탭 인덱스를 현재 인덱스에 할당
        tabBar.selectedTabIndexPublisher
            .assign(to: &$currentTabIndex)
    }
}
