//
//  Publisher+Result.swift
//  BoraKit
//
//  Created by 신정욱 on 6/2/25.
//

import Foundation
import Combine

extension Publisher {
    /// Result 스트림에서 성공(Success) 값만 필터링하여 추출
    public func onlyValues<Value, ResultFailure>() -> AnyPublisher<Value, Never>
    where Output == Result<Value, ResultFailure>, Failure == Never {
        return self
            .compactMap { result -> Value? in
                // 패턴 매칭으로 성공 값만 꺼내고, 실패인 경우는 nil을 반환해 스트림에서 무시
                guard case let .success(value) = result else { return nil }
                return value
            }
            .eraseToAnyPublisher()
    }
    
    /// Result 스트림에서 실패(Failure) 에러만 필터링하여 추출
    public func onlyErrors<Value, ResultFailure>() -> AnyPublisher<ResultFailure, Never>
    where Output == Result<Value, ResultFailure>, Failure == Never {
        return self
            .compactMap { result -> ResultFailure? in
                // 패턴 매칭으로 에러만 꺼내고, 성공인 경우는 nil을 반환해 스트림에서 무시
                guard case let .failure(error) = result else { return nil }
                return error
            }
            .eraseToAnyPublisher()
    }
}
