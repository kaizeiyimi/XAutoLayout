//
//  ConstraintGeneration.swift
//  XAutoLayout
//
//  Created by kaizei on 2017/7/20.
//  Copyright © 2017年 kaizei.yimi. All rights reserved.
//

import Foundation

infix operator =/
infix operator <=/
infix operator >=/

// MARK: - single =

@discardableResult
public func =/<L: NSAnchor, R: Anchor>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L.AnchorType == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .equal, rhs: rhs.makeExtendedAnchor())
}

@discardableResult
public func <=/<L: NSAnchor, R: Anchor>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L.AnchorType == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .lessThanOrEqual, rhs: rhs.makeExtendedAnchor())
}

@discardableResult
public func >=/<L: NSAnchor, R: Anchor>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L.AnchorType == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .greaterThanOrEqual, rhs: rhs.makeExtendedAnchor())
}


// MARK: - container

@discardableResult
public func xmakeConstraints(autoActive: Bool = true, _ construction: () -> Void) -> [NSLayoutConstraint] {
    Context.stack.append(Context(autoActive: autoActive))
    construction()
    let constraints = Context.stack.removeLast().constraints
    if autoActive {
        NSLayoutConstraint.activate(constraints)
    }
    return constraints
}

private final class Context {
    let autoActive: Bool
    var constraints: [NSLayoutConstraint] = []
    
    static var stack: [Context] = []
    
    init(autoActive: Bool = false) {
        self.autoActive = autoActive
    }
}

private func generate<T>(lhs: ExtendedAnchor<T>, relation: NSLayoutRelation, rhs: ExtendedAnchor<T>) -> NSLayoutConstraint {
    let constraint: NSLayoutConstraint
    
    if let left = lhs.anchor as? NSLayoutDimension {
        let right = rhs.anchor as! NSLayoutDimension
        switch relation {
        case .equal: constraint = left.constraint(equalTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
        case .lessThanOrEqual: constraint = left.constraint(lessThanOrEqualTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
        case .greaterThanOrEqual: constraint = left.constraint(greaterThanOrEqualTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
        }
    } else if let left = lhs.anchor as? NSLayoutAnchor<T> {
        let right = rhs.anchor as! NSLayoutAnchor<T>
        switch relation {
        case .equal: constraint = left.constraint(equalTo: right, constant: rhs.constant)
        case .lessThanOrEqual: constraint = left.constraint(lessThanOrEqualTo: right, constant: rhs.constant)
        case .greaterThanOrEqual: constraint = left.constraint(greaterThanOrEqualTo: right, constant: rhs.constant)
        }
    } else {
        fatalError("maybe new anchor class?")
    }
    constraint.priority = rhs.priority
    
    if let context = Context.stack.last {
        context.constraints.append(constraint)
    } else {
        constraint.isActive = true
    }
    
    return constraint
}
