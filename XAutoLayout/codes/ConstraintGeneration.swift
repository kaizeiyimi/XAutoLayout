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

// MARK: - single

@discardableResult
public func =/<A>(_ lhs: A, _ rhs: A) -> NSLayoutConstraint where A: Anchor {
    return generate(lhs: lhs, relation: .equal, rhs: rhs)
}

@discardableResult
public func <=/<A>(_ lhs: A, _ rhs: A) -> NSLayoutConstraint where A: Anchor {
    return generate(lhs: lhs, relation: .lessThanOrEqual, rhs: rhs)
}

@discardableResult
public func >=/<A>(_ lhs: A, _ rhs: A) -> NSLayoutConstraint where A: Anchor {
    return generate(lhs: lhs, relation: .greaterThanOrEqual, rhs: rhs)
}

// MARK: - group

@discardableResult
public func =/<A1, A2>(_ lhs: (A1, A2), _ rhs: (A1?, A2?)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1), toOptinalAnyArray(rhs.0, rhs.1))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

@discardableResult
public func =/<A1, A2>(_ lhs: (A1, A2), _ rhs: (A1, A2)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1), toOptinalAnyArray(rhs.0, rhs.1))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

@discardableResult
public func =/<A1, A2, A3>(_ lhs: (A1, A2, A3), _ rhs: (A1?, A2?, A3?)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor, A3: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1, lhs.2), toOptinalAnyArray(rhs.0, rhs.1, rhs.2))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

@discardableResult
public func =/<A1, A2, A3>(_ lhs: (A1, A2, A3), _ rhs: (A1, A2, A3)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor, A3: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1, lhs.2), toOptinalAnyArray(rhs.0, rhs.1, rhs.2))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

@discardableResult
public func =/<A1, A2, A3, A4>(_ lhs: (A1, A2, A3, A4), _ rhs: (A1?, A2?, A3?, A4?)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor, A3: Anchor, A4: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1, lhs.2, lhs.3), toOptinalAnyArray(rhs.0, rhs.1, rhs.2, rhs.3))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

@discardableResult
public func =/<A1, A2, A3, A4>(_ lhs: (A1, A2, A3, A4), _ rhs: (A1, A2, A3, A4)) -> [NSLayoutConstraint]
    where A1: Anchor, A2: Anchor, A3: Anchor, A4: Anchor {
        return zip( toOptinalAnyArray(lhs.0, lhs.1, lhs.2, lhs.3), toOptinalAnyArray(rhs.0, rhs.1, rhs.2, rhs.3))
            .filter{ $0.0 != nil && $0.1 != nil }
            .map{ generate(lhs: $0.0!, relation: .equal, rhs: $0.1!) }
}

private func toOptinalAnyArray(_ values: Any?...) -> [Any?] {
    return values
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
    
    init(autoActive: Bool) {
        self.autoActive = autoActive
    }
}

private func generate(lhs: Any, relation: NSLayoutConstraint.Relation, rhs: Any) -> NSLayoutConstraint {
    let constraint: NSLayoutConstraint
    
    if let lhs = lhs as? NSLayoutDimension {
        let rhs = rhs as! NSLayoutDimension
        let lItem = (lhs.origin ?? lhs) as! NSLayoutDimension
        let rItem = (rhs.origin ?? rhs) as! NSLayoutDimension
        if rhs.isNumDimension {
            let constant = rhs.xConstant * rhs.xMultiplier
            switch relation {
            case .equal: constraint = lItem.constraint(equalToConstant: constant)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualToConstant: constant)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualToConstant: constant)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        } else {
            switch relation {
            case .equal: constraint = lItem.constraint(equalTo: rItem, multiplier: rhs.xMultiplier, constant: rhs.xConstant)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualTo: rItem, multiplier: rhs.xMultiplier, constant: rhs.xConstant)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualTo: rItem, multiplier: rhs.xMultiplier, constant: rhs.xConstant)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        }
    } else if let lhs = lhs as? NSLayoutXAxisAnchor {
        let rhs = rhs as! NSLayoutXAxisAnchor
        let lItem = (lhs.origin ?? lhs) as! NSLayoutXAxisAnchor
        let rItem = (rhs.origin ?? rhs) as! NSLayoutXAxisAnchor
        if rhs.useSystemSpace, #available(iOS 11, *) {
            switch relation {
            case .equal: constraint = lItem.constraint(equalToSystemSpacingAfter: rItem, multiplier: rhs.xMultiplier)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualToSystemSpacingAfter: rItem, multiplier: rhs.xMultiplier)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualToSystemSpacingAfter: rItem, multiplier: rhs.xMultiplier)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        } else {
            switch relation {
            case .equal: constraint = lItem.constraint(equalTo: rItem, constant: rhs.xConstant)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualTo: rItem, constant: rhs.xConstant)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualTo: rItem, constant: rhs.xConstant)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        }
    } else if let lhs = lhs as? NSLayoutYAxisAnchor {
        let rhs = rhs as! NSLayoutYAxisAnchor
        let lItem = (lhs.origin ?? lhs) as! NSLayoutYAxisAnchor
        let rItem = (rhs.origin ?? rhs) as! NSLayoutYAxisAnchor
        if rhs.useSystemSpace, #available(iOS 11, *) {
            switch relation {
            case .equal: constraint = lItem.constraint(equalToSystemSpacingBelow: rItem, multiplier: rhs.xMultiplier)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualToSystemSpacingBelow: rItem, multiplier: rhs.xMultiplier)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualToSystemSpacingBelow: rItem, multiplier: rhs.xMultiplier)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        } else {
            switch relation {
            case .equal: constraint = lItem.constraint(equalTo: rItem, constant: rhs.xConstant)
            case .lessThanOrEqual: constraint = lItem.constraint(lessThanOrEqualTo: rItem, constant: rhs.xConstant)
            case .greaterThanOrEqual: constraint = lItem.constraint(greaterThanOrEqualTo: rItem, constant: rhs.xConstant)
            @unknown default:
                fatalError("non supported constraint relation")
            }
        }
    } else {
        fatalError("maybe new anchor class?")
    }
    constraint.priority = (rhs as! NSObject).xPriority
    
    if let context = Context.stack.last {
        context.constraints.append(constraint)
    } else {
        constraint.isActive = true
    }
    
    return constraint
}

