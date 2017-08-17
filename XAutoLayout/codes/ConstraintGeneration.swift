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

private func generate(lhs: Any, relation: NSLayoutRelation, rhs: Any) -> NSLayoutConstraint {
    let constraint: NSLayoutConstraint
    
    if let lhs = lhs as? NSLayoutDimension {
        if let rhs = rhs as? Num {
            let constant = rhs.constant * rhs.multiplier
            switch relation {
            case .equal: constraint = lhs.constraint(equalToConstant: constant)
            case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualToConstant: constant)
            case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualToConstant: constant)
            }
        } else {
            let rhs = rhs as! NSLayoutDimension
            switch relation {
            case .equal: constraint = lhs.constraint(equalTo: rhs, multiplier: rhs.multiplier, constant: rhs.constant)
            case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualTo: rhs, multiplier: rhs.multiplier, constant: rhs.constant)
            case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualTo: rhs, multiplier: rhs.multiplier, constant: rhs.constant)
            }
        }
    } else if let lhs = lhs as? NSLayoutXAxisAnchor {
        let rhs = rhs as! NSLayoutXAxisAnchor
        #if swift(>=3.2)
            if rhs.useSystemSpace, #available(iOS 11, *) {
                switch relation {
                case .equal: constraint = lhs.constraintEqualToSystemSpacingAfter(rhs, multiplier: rhs.multiplier)
                case .lessThanOrEqual: constraint = lhs.constraintLessThanOrEqualToSystemSpacingAfter(rhs, multiplier: rhs.multiplier)
                case .greaterThanOrEqual: constraint = lhs.constraintGreaterThanOrEqualToSystemSpacingAfter(rhs, multiplier: rhs.multiplier)
                }
            } else {
                switch relation {
                case .equal: constraint = lhs.constraint(equalTo: rhs, constant: rhs.constant)
                case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: rhs.constant)
                case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: rhs.constant)
                }
            }
        #else
            switch relation {
            case .equal: constraint = lhs.constraint(equalTo: rhs, constant: rhs.constant)
            case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: rhs.constant)
            case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: rhs.constant)
            }
        #endif
    } else if let lhs = lhs as? NSLayoutYAxisAnchor {
        let rhs = rhs as! NSLayoutYAxisAnchor
        #if swift(>=3.2)
            if rhs.useSystemSpace, #available(iOS 11, *) {
                switch relation {
                case .equal: constraint = lhs.constraintEqualToSystemSpacingBelow(rhs, multiplier: rhs.multiplier)
                case .lessThanOrEqual: constraint = lhs.constraintLessThanOrEqualToSystemSpacingBelow(rhs, multiplier: rhs.multiplier)
                case .greaterThanOrEqual: constraint = lhs.constraintGreaterThanOrEqualToSystemSpacingBelow(rhs, multiplier: rhs.multiplier)
                }
            } else {
                switch relation {
                case .equal: constraint = lhs.constraint(equalTo: rhs, constant: rhs.constant)
                case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: rhs.constant)
                case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: rhs.constant)
                }
            }
        #else
            switch relation {
            case .equal: constraint = lhs.constraint(equalTo: rhs, constant: rhs.constant)
            case .lessThanOrEqual: constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: rhs.constant)
            case .greaterThanOrEqual: constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: rhs.constant)
            }
        #endif
    } else {
        fatalError("maybe new anchor class?")
    }
    constraint.priority = (rhs as! NSObject).priority
    
    if let context = Context.stack.last {
        context.constraints.append(constraint)
    } else {
        constraint.isActive = true
    }
    
    return constraint
}
