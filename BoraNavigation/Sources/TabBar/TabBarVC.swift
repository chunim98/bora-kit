//
//  TabBarVC.swift
//  LinkAndLeave
//
//  Created by 신정욱 on 12/3/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

class TabBarVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    /// 현재 탭 인덱스
    @Published var currentTabIndex = 0
    
    // MARK: Subjects
    
    /// 로그인 요청 서브젝트 (출력)
    private let loginRequiredSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    /// 각 탭을 구성하는 뷰컨들
    private let tabVCs: [UIViewController]
    
    /// 각 탭의 컨텐츠가 담기는 뷰
    private let contentView = UIView()
    
    /// 하단 탭바
    private let tabBar: TabBar
    
    // MARK: Life Cycle
    
    // 나중에 Configuration 만들어서,
    // 뷰컨이랑 버튼을 한 쌍으로 초기화하도록 묶어줄 필요는 있을 듯..
    init(
        tabVCs: [UIViewController],
        buttons: [TabBarComponentButton]
    ) {
        self.tabVCs = tabVCs
        self.tabBar = TabBar(with: buttons)
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
        view.addSubview(contentView)
        view.addSubview(tabBar)
        
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tabBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(TabBar.height)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 처음 탭 뷰컨을 로드
        /// - 첫 방출 1번만 실행
        $currentTabIndex
            .prefix(1)
            .sink { [weak self] in self?.loadInitialVC(with: $0) }
            .store(in: &cancellables)
        
        /// 이후 방출은 전부 transition
        $currentTabIndex
            .dropFirst()
            .sink { [weak self] in self?.transition(to: $0) }
            .store(in: &cancellables)
        
        /// 현재 탭 인덱스 상태에 따라 탭바의 UI 갱신
        $currentTabIndex
            .sink { [weak self] in self?.tabBar.updateUI(with: $0) }
            .store(in: &cancellables)
        
        /// 탭 선택 이벤트를 수신하여 화면 전환 처리
        /// - 0.2초 스로틀을 적용해 과도한 화면 전환(Rapid Taps) 방지
        tabBar.selectedIndexPublisher
            .throttle(for: .seconds(0.2), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in self?.handleTabSelection(index: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension TabBarVC {
    /// 탭 선택 시 인증 상태를 확인하여 화면 전환 또는 로그인 유도
    /// - 인증이 필요한 탭 접근 시 미인증 상태라면 로그인 화면을 띄움
    private func handleTabSelection(index: Int) {
        let isAuthenticated = AuthManager.shared.authState == .valid
        let isAuthRequired = index == 1
        
        if isAuthRequired && !isAuthenticated {
            loginRequiredSubject.send(())
        } else {
            currentTabIndex = index
        }
    }
    
    /// 처음 탭 뷰컨을 로드
    /// - 1회만 실행되고 이후 화면전환은 transition(to:)를 사용함
    private func loadInitialVC(with index: Int) {
        let initialVC = tabVCs[index]
        
        addChild(initialVC)
        contentView.addSubview(initialVC.view)
        initialVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        initialVC.didMove(toParent: self)
    }
    
    /// 선택한 인덱스의 탭으로 이동
    private func transition(to index: Int) {
        // @Published의 send이벤트는 willSet블럭에서 실행되기 때문에 가드문을 통과할 수 있음
        guard currentTabIndex != index else { return }
        
        let preVC = tabVCs[currentTabIndex]
        let newVC = tabVCs[index]
        
        // 전환 중 사용자의 중복 클릭이나 이전 화면의 조작 방지
        preVC.view.isUserInteractionEnabled = false
        newVC.view.isUserInteractionEnabled = true
        
        // 새로운 뷰컨을 컨테이너에 추가 (생명주기 시작)
        addChild(newVC)
        contentView.addSubview(newVC.view)
        newVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        newVC.didMove(toParent: self)
        
        // 새 뷰 애니메이션 시작 상태 세팅
        newVC.view.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        newVC.view.alpha = 0
        
        // 애니메이션 효과
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            // 새 뷰 등장 애니메이션
            newVC.view.transform = .identity
            newVC.view.alpha = 1
            
        } completion: { _ in
            // 이전 뷰컨의 생명주기 종료 및 뷰 계층에서 제거
            preVC.willMove(toParent: nil)
            preVC.view.removeFromSuperview()
            preVC.removeFromParent()
        }
    }
    
    /// 로그인 요청 퍼블리셔
    var loginRequiredPublisher: AnyPublisher<Void, Never> {
        loginRequiredSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    let tabBarCoord = TabBarCoord()
    tabBarCoord.start()
    return tabBarCoord.navigation
}
