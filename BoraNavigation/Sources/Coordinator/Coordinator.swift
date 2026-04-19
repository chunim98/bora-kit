//
//  Coordinator.swift
//  BoraScaffold
//
//  Created by 신정욱 on 4/6/26.
//

import UIKit
import Combine

/// 앱의 네비게이션 흐름을 제어하는 기본 단위
open class Coordinator: NSObject {
    
    // MARK: Properties
    
    /// 하위 흐름을 관리하기 위한 자식 코디네이터 참조 배열
    /// - Note: 자식의 생명주기를 유지하기 위해 강한 참조를 보관해야 함
    public var children: [Coordinator] = []
    
    /// 화면 전환을 수행할 내비게이션 컨트롤러
    public let navigation: UINavigationController
    
    /// Combine 구독 생명주기 보관소
    public var cancellables = Set<AnyCancellable>()
    
    // MARK: Subjects
    
    /// 코디네이터 종료 이벤트 서브젝트 (출력)
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Life Cycle
    
    public init(navigation: UINavigationController) {
        print("[\(type(of: self))] 시작")
        self.navigation = navigation
    }
    
    deinit { print("[\(type(of: self))] 종료") }
    
    // MARK: Helpers
    
    /// 특정 자식 코디네이터를 해제하여 메모리에서 제거
    public func free(child: Coordinator?) {
        children.removeAll { $0 === child }
    }
    
    /// 자식 코디네이터를 배열에 추가하여 생명주기 관리 시작
    public func store(child: Coordinator) {
        children.append(child)
    }
    
    /// 코디네이터 종료 이벤트 외부(부모)에 전달
    public func finish() {
        didFinishSubject.send(())
    }
}

// MARK: Combine Interface

extension Coordinator {
    /// 코디네이터 종료 이벤트 스트림
    /// - 부모에서 이 이벤트를 구독해서 자식을 정리
    public var didFinishPublisher: AnyPublisher<Void, Never> {
        didFinishSubject.eraseToAnyPublisher()
    }
}
