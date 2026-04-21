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
    
    // 나중에 Configuration 만들어서,
    // 뷰컨이랑 버튼을 한 쌍으로 초기화하도록 묶어줄 필요는 있을 듯..
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
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
        
        /// 현재 탭 인덱스 상태에 따라 탭바의 UI 갱신
        $currentTabIndex
            .sink { [weak self] index in
                self?.viewControllers[safe: index].map {
                    self?.tabContainerVC.transition(to: $0)
                }
//                self?.tabBar.updateUI(with: $0)
            }
            .store(in: &cancellables)
    }
}
