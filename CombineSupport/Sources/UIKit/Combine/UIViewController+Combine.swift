//
//  UIViewController+Combine.swift
//  BoraKit
//
//  Created by Codex on 4/24/26.
//

import UIKit
import Combine

/// UIViewController 생명주기 퍼블리셔 저장소
private final class UIViewControllerLifecycleStorage {
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    let viewWillLayoutSubviewsSubject = PassthroughSubject<Void, Never>()
    let viewDidLayoutSubviewsSubject = PassthroughSubject<Void, Never>()
    let viewDidAppearSubject = PassthroughSubject<Void, Never>()
    let viewWillDisappearSubject = PassthroughSubject<Void, Never>()
    let viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    let deallocatedSubject = PassthroughSubject<Void, Never>()
    
    deinit {
        deallocatedSubject.send(())
    }
}

/// 생명주기 퍼블리셔 저장소의 연관 객체 키
fileprivate nonisolated(unsafe) var lifecycleStorageKey: UInt8 = 0

/// UIViewController 생명주기 메서드 스위즐링
private enum UIViewControllerLifecycleSwizzler {
    nonisolated(unsafe) private static var isInstalled = false
    
    static func installIfNeeded() {
        guard !isInstalled else { return }
        isInstalled = true
        
        swizzle(
            #selector(UIViewController.viewDidLoad),
            #selector(UIViewController.bk_viewDidLoad)
        )
        swizzle(
            #selector(UIViewController.viewWillAppear(_:)),
            #selector(UIViewController.bk_viewWillAppear(_:))
        )
        swizzle(
            #selector(UIViewController.viewWillLayoutSubviews),
            #selector(UIViewController.bk_viewWillLayoutSubviews)
        )
        swizzle(
            #selector(UIViewController.viewDidLayoutSubviews),
            #selector(UIViewController.bk_viewDidLayoutSubviews)
        )
        swizzle(
            #selector(UIViewController.viewDidAppear(_:)),
            #selector(UIViewController.bk_viewDidAppear(_:))
        )
        swizzle(
            #selector(UIViewController.viewWillDisappear(_:)),
            #selector(UIViewController.bk_viewWillDisappear(_:))
        )
        swizzle(
            #selector(UIViewController.viewDidDisappear(_:)),
            #selector(UIViewController.bk_viewDidDisappear(_:))
        )
    }
    
    private static func swizzle(
        _ originalSelector: Selector,
        _ swizzledSelector: Selector
    ) {
        guard
            let originalMethod = class_getInstanceMethod(
                UIViewController.self,
                originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                UIViewController.self,
                swizzledSelector
            )
        else { return }
        
        method_exchangeImplementations(
            originalMethod,
            swizzledMethod
        )
    }
}

extension UIViewController {
    /// 생명주기 퍼블리셔 스위즐링 설치
    public static func installLifecyclePublishers() {
        UIViewControllerLifecycleSwizzler.installIfNeeded()
    }
    
    private var lifecycleStorage: UIViewControllerLifecycleStorage {
        UIViewControllerLifecycleSwizzler.installIfNeeded()
        
        if let storage = objc_getAssociatedObject(
            self,
            &lifecycleStorageKey
        ) as? UIViewControllerLifecycleStorage {
            return storage
        }
        
        let storage = UIViewControllerLifecycleStorage()
        objc_setAssociatedObject(
            self,
            &lifecycleStorageKey,
            storage,
            .OBJC_ASSOCIATION_RETAIN
        )
        return storage
    }
    
    private var currentLifecycleStorage: UIViewControllerLifecycleStorage? {
        objc_getAssociatedObject(
            self,
            &lifecycleStorageKey
        ) as? UIViewControllerLifecycleStorage
    }
    
    /// viewDidLoad 이벤트 퍼블리셔
    public var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidLoadSubject.eraseToAnyPublisher()
    }
    
    /// viewWillAppear 이벤트 퍼블리셔
    public var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillLayoutSubviews 이벤트 퍼블리셔
    public var viewWillLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidLayoutSubviews 이벤트 퍼블리셔
    public var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidAppear 이벤트 퍼블리셔
    public var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillDisappear 이벤트 퍼블리셔
    public var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillDisappearSubject.eraseToAnyPublisher()
    }
    
    /// viewDidDisappear 이벤트 퍼블리셔
    public var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidDisappearSubject.eraseToAnyPublisher()
    }
    
    /// deinit 이벤트 퍼블리셔
    public var deallocatedPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.deallocatedSubject.eraseToAnyPublisher()
    }
    
    @objc dynamic fileprivate func bk_viewDidLoad() {
        bk_viewDidLoad()
        currentLifecycleStorage?.viewDidLoadSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewWillAppear(_ animated: Bool) {
        bk_viewWillAppear(animated)
        currentLifecycleStorage?.viewWillAppearSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewWillLayoutSubviews() {
        bk_viewWillLayoutSubviews()
        currentLifecycleStorage?.viewWillLayoutSubviewsSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewDidLayoutSubviews() {
        bk_viewDidLayoutSubviews()
        currentLifecycleStorage?.viewDidLayoutSubviewsSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewDidAppear(_ animated: Bool) {
        bk_viewDidAppear(animated)
        currentLifecycleStorage?.viewDidAppearSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewWillDisappear(_ animated: Bool) {
        bk_viewWillDisappear(animated)
        currentLifecycleStorage?.viewWillDisappearSubject.send(())
    }
    
    @objc dynamic fileprivate func bk_viewDidDisappear(_ animated: Bool) {
        bk_viewDidDisappear(animated)
        currentLifecycleStorage?.viewDidDisappearSubject.send(())
    }
}
