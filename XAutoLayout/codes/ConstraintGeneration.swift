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
public func =/<L, R>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L: NSAnchor, R: Anchor, L == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .equal, rhs: rhs.makeExtendedAnchor())
}

@discardableResult
public func <=/<L, R>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L: NSAnchor, R: Anchor, L == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .lessThanOrEqual, rhs: rhs.makeExtendedAnchor())
}

@discardableResult
public func >=/<L, R>(_ lhs: L, _ rhs: R) -> NSLayoutConstraint where L: NSAnchor, R: Anchor, L == R.AnchorType {
    return generate(lhs: lhs.makeExtendedAnchor(), relation: .greaterThanOrEqual, rhs: rhs.makeExtendedAnchor())
}

// MARK: - multi

@discardableResult
public func =/<L>(_ lhs: [L], _ rhs: [XAxisAnchor?]) -> [NSLayoutConstraint] where L: NSAnchor, L: XAxisAnchor {
    return zip(lhs, rhs).filter{$0.1 != nil}.map{ pair in
        generate(lhs: pair.0.makeExtendedAnchor(), relation: .equal, rhs: pair.1!.makeExtendedAnchor())
    }
}

@discardableResult
public func =/<L>(_ lhs: [L], _ rhs: [YAxisAnchor?]) -> [NSLayoutConstraint] where L: NSAnchor, L: YAxisAnchor {
    return zip(lhs, rhs).filter{$0.1 != nil}.map{ pair in
        generate(lhs: pair.0.makeExtendedAnchor(), relation: .equal, rhs: pair.1!.makeExtendedAnchor())
    }
}

@discardableResult
public func =/<L>(_ lhs: [L], _ rhs: [Dimension?]) -> [NSLayoutConstraint] where L: NSAnchor, L: Dimension {
    return zip(lhs, rhs).filter{$0.1 != nil}.map{ pair in
        generate(lhs: pair.0.makeExtendedAnchor(), relation: .equal, rhs: pair.1!.makeExtendedAnchor())
    }
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

private func generate(lhs: ExtendedAnchor, relation: NSLayoutRelation, rhs: ExtendedAnchor) -> NSLayoutConstraint {
    let constraint: NSLayoutConstraint
    
    if let left = lhs.anchor as? NSLayoutDimension {
        if rhs.anchor != nil {
            let right = rhs.anchor as! NSLayoutDimension
            switch relation {
            case .equal: constraint = left.constraint(equalTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
            case .lessThanOrEqual: constraint = left.constraint(lessThanOrEqualTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
            case .greaterThanOrEqual: constraint = left.constraint(greaterThanOrEqualTo: right, multiplier: rhs.multiplier, constant: rhs.constant)
            }
        } else {
            let right = rhs.constant * rhs.multiplier
            switch relation {
            case .equal: constraint = left.constraint(equalToConstant: right)
            case .lessThanOrEqual: constraint = left.constraint(lessThanOrEqualToConstant: right)
            case .greaterThanOrEqual: constraint = left.constraint(greaterThanOrEqualToConstant: right)
            }
        }
    } else if let left = lhs.anchor as? NSLayoutXAxisAnchor {
        let right = rhs.anchor as! NSLayoutXAxisAnchor
        switch relation {
        case .equal: constraint = left.constraint(equalTo: right, constant: rhs.constant)
        case .lessThanOrEqual: constraint = left.constraint(lessThanOrEqualTo: right, constant: rhs.constant)
        case .greaterThanOrEqual: constraint = left.constraint(greaterThanOrEqualTo: right, constant: rhs.constant)
        }
    } else if let left = lhs.anchor as? NSLayoutYAxisAnchor {
        let right = rhs.anchor as! NSLayoutYAxisAnchor
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
