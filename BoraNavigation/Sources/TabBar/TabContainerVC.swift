//
//  TabContainerVC.swift
//  BoraKit
//
//  Created by 신정욱 on 4/21/26.
//

import UIKit
import Combine

/// 여러 자식 뷰컨트롤러 중 하나를 선택해 보여주는 탭 컨테이너
public final class TabContainerVC: UIViewController {
    
    // MARK: Properties
    
    private let viewControllers: [UIViewController]
    private let contentView = UIView()
    
    @Published public private(set) var currentIndex: Int
    
    public var currentViewController: UIViewController {
        viewControllers[currentIndex]
    }
    
    public var currentIndexPublisher: AnyPublisher<Int, Never> {
        $currentIndex.eraseToAnyPublisher()
    }
    
    // MARK: Life Cycle
    
    public init(
        viewControllers: [UIViewController],
        initialIndex: Int = 0
    ) {
        precondition(!viewControllers.isEmpty, "viewControllers must not be empty.")
        precondition(viewControllers.indices.contains(initialIndex), "initialIndex is out of range.")
        
        self.viewControllers = viewControllers
        self.currentIndex = initialIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadInitialViewController()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Selection
    
    public func selectTab(
        at index: Int,
        animated: Bool = true
    ) {
        guard viewControllers.indices.contains(index) else { return }
        guard currentIndex != index else { return }
        
        let previousIndex = currentIndex
        currentIndex = index
        
        guard isViewLoaded else { return }
        
        transition(
            from: viewControllers[previousIndex],
            to: viewControllers[index],
            animated: animated
        )
    }
}

// MARK: - Transition

private extension TabContainerVC {
    func loadInitialViewController() {
        let viewController = currentViewController
        
        addChild(viewController)
        contentView.addSubview(viewController.view)
        setupContentLayout(for: viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func transition(
        from previousViewController: UIViewController,
        to nextViewController: UIViewController,
        animated: Bool
    ) {
        previousViewController.view.isUserInteractionEnabled = false
        
        addChild(nextViewController)
        contentView.addSubview(nextViewController.view)
        setupContentLayout(for: nextViewController.view)
        nextViewController.view.isUserInteractionEnabled = true
        
        previousViewController.willMove(toParent: nil)
        
        let animations = {
            nextViewController.view.alpha = 1
            nextViewController.view.transform = .identity
        }
        
        let completion: (Bool) -> Void = { _ in
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
            nextViewController.didMove(toParent: self)
        }
        
        guard animated else {
            completion(true)
            return
        }
        
        nextViewController.view.alpha = 0
        nextViewController.view.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseOut],
            animations: animations,
            completion: completion
        )
    }
    
    func setupContentLayout(for childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: contentView.topAnchor),
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
