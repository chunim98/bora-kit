//
//  Comparable+.swift
//  BoraKit
//
//  Created by 신정욱 on 5/28/25.
//

extension Comparable {
    public func clamped(_ range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
