//
//  Weak.swift
//  BoraKit
//
//  Created by 신정욱 on 1/13/26.
//

/// 약한 참조를 담을 수 있는 컨테이너
public struct Weak<T: AnyObject> {
    public weak var value: T?
    
    public init(_ value: T?) {
        self.value = value
    }
}
