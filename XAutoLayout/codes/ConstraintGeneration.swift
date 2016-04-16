//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

/// defines the relations that first item can make.
public protocol RelationMakeable: AttributeContainer {
    func equal(other: AttributeContainer) -> NSLayoutConstraint
    func lessOrEqual(other: AttributeContainer) -> NSLayoutConstraint
    func greaterOrEqual(other: AttributeContainer) -> NSLayoutConstraint
}

extension XAttribute: RelationMakeable {}

public extension RelationMakeable {
    public func equal(other: AttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .Equal, right: other)
    }
    
    public func lessOrEqual(other: AttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .LessThanOrEqual, right: other)
    }
    
    public func greaterOrEqual(other: AttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .GreaterThanOrEqual, right: other)
    }
}

infix operator =/ {}
infix operator <=/ {}
infix operator >=/ {}

public func =/(left: RelationMakeable, right: AttributeContainer) -> NSLayoutConstraint { return left.equal(right) }
public func <=/(left: RelationMakeable, right: AttributeContainer) -> NSLayoutConstraint { return left.lessOrEqual(right) }
public func >=/(left: RelationMakeable, right: AttributeContainer) -> NSLayoutConstraint { return left.greaterOrEqual(right) }

public func =/(left: [RelationMakeable], right: [RelationMakeable]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }
public func =/(left: [RelationMakeable], right: [RelationMakeable?]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }
public func =/(left: [RelationMakeable], right: [AttributeContainer]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }
public func =/(left: [RelationMakeable], right: [AttributeContainer?]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [RelationMakeable], _ right: [RelationMakeable]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as AttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [RelationMakeable], _ right: [RelationMakeable?]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as AttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [RelationMakeable], _ right: [AttributeContainer]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as AttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [RelationMakeable], _ right: [AttributeContainer?]) -> [NSLayoutConstraint] {
    return zip(left, right).filter{ $0.1 != nil }.map { $0.0.equal($0.1!) }
}

public enum Direction {
    case LeadingToTrailing
    case LeftToRight
    case RightToLeft
    
    public init?(_ layoutFormatOption: NSLayoutFormatOptions) {
        switch layoutFormatOption {
        case NSLayoutFormatOptions.DirectionLeadingToTrailing: self = .LeadingToTrailing
        case NSLayoutFormatOptions.DirectionLeftToRight: self = .LeftToRight
        case NSLayoutFormatOptions.DirectionRightToLeft: self = .RightToLeft
        default: return nil
        }
    }
    
    public var layoutFormatOption: NSLayoutFormatOptions {
        switch self {
        case .LeadingToTrailing: return NSLayoutFormatOptions.DirectionLeadingToTrailing
        case .LeftToRight: return NSLayoutFormatOptions.DirectionLeftToRight
        case .RightToLeft: return NSLayoutFormatOptions.DirectionRightToLeft
        }
    }
        
}

/** 
 make constraints. *direction* and *autoActive* can be specified to adjust constraints.
 
 system has some strange behavior like it allows Top and Left to have a constraint, 
 but crashs you when Left/Right and Leading/Trailing want to have a constraint.
 
 iOS9 will crash if constraint is make between Leading/Trailing to Left/Right,
 but has no problem between Leading/Trailing and other anchors.
 
 when working with Direction, we change Leading/Trailing to Left/Right as VFL do if needed,
 but have no idea about should change or not when only one attribute is Leading/Trailing **and** direction is L2R or R2L **and** other is not horizontal anchor.
 so I will crash you.
 
 you would better follow a normal layout mind, do not try any tricky things.
 */
public func xmakeConstraints(direction: Direction = .LeadingToTrailing, autoActive: Bool = true, @noescape _ construction: ()->Void) -> [NSLayoutConstraint] {
    Context.stack.append(Context(direction: direction, autoActive: autoActive))
    construction()
    return Context.stack.removeLast().constraints
}


private class Context {
    
    let direction: Direction
    let autoActive: Bool
    var constraints: [NSLayoutConstraint] = []
    
    static var stack: [Context] = [Context()]
    
    init(direction: Direction = .LeadingToTrailing, autoActive: Bool = false) {
        self.direction = direction
        self.autoActive = autoActive
    }
    
    func make(left:RelationMakeable, relation: NSLayoutRelation, right: AttributeContainer) -> NSLayoutConstraint {
        let (first, second) = adjustAttributes(first: left.generateX(), second: right.generateX())
        let constraint = NSLayoutConstraint(item: first.item!, attribute: first.attr, relatedBy: relation, toItem: second.item, attribute: second.attr, multiplier: second.multiplier, constant: second.constant)
        constraint.priority = second.priority
        constraint.active = autoActive
        constraints.append(constraint)
        return constraint
    }
    
    func adjustAttributes(first first: XAttributeX, second: XAttributeX) -> (first: XAttributeX, second: XAttributeX) {
        crashIfNeeded(firstAttr: first.attr, secondAttr: second.attr, direction: direction)
        var attributes = (firstItem: first.item!, firstAttr: first.attr, secondItem: second.item, secondAttr: second.attr, constant: second.constant)
        // number
        if attributes.firstAttr != .Width && attributes.firstAttr != .Height && attributes.secondItem == nil && attributes.secondAttr == .NotAnAttribute {
            if let firstView = attributes.firstItem as? UIView {
                attributes.secondItem = firstView.superview
                attributes.secondAttr = attributes.firstAttr
            }
        }
        // direction
        func adjust(attr: NSLayoutAttribute) -> NSLayoutAttribute {
            switch attr {
            case .Leading: return direction == .LeftToRight ? .Left : (direction == .RightToLeft ? .Right : attr)
            case .LeadingMargin: return direction == .LeftToRight ? .LeftMargin : (direction == .RightToLeft ? .RightMargin : attr)
            case .Trailing: return direction == .LeftToRight ? .Right : (direction == .RightToLeft ? .Left : attr)
            case .TrailingMargin: return direction == .LeftToRight ? .RightMargin : (direction == .RightToLeft ? .LeftMargin : attr)
            default:
                return attr
            }
        }
        let (adjustedFirstAttr, adjustedSecondAttr) = (adjust(attributes.firstAttr), adjust(attributes.secondAttr))
        
        // constant convert. since pair is checked, here we only need to check firstAttr.
        if attributes.firstAttr != adjustedFirstAttr && direction == .RightToLeft {
            attributes.constant = -attributes.constant
        }
        (attributes.firstAttr, attributes.secondAttr) = (adjustedFirstAttr, adjustedSecondAttr)
        
        return (XAttributeX(other: first, attr: attributes.firstAttr), XAttributeX(other: second, item: attributes.secondItem, attr: attributes.secondAttr, constant: attributes.constant))
    }
}


// apple only check horizontal attr, and crashs app in iOS9 if pair is not satisfied.
private func crashIfNeeded(firstAttr firstAttr: NSLayoutAttribute, secondAttr: NSLayoutAttribute, direction: Direction) {
    guard direction != .LeadingToTrailing else { return }
    
    let Normal = 0, NotAnAttribute = 1, Dimension = 2, LeadingTailingAnchor = 3, LeftRightAnchor = 4
    func convert(attr: NSLayoutAttribute) -> Int {
        switch attr {
        case .Leading, .LeadingMargin, .Trailing, .TrailingMargin:
            return LeadingTailingAnchor
        case .Left, .LeftMargin, .Right, .RightMargin:
            return LeftRightAnchor
        case .Width, .Height:
            return Dimension
        case .NotAnAttribute:
            return NotAnAttribute
        default:
            return Normal
        }
    }
    switch (convert(firstAttr), convert(secondAttr)) {
    case (LeadingTailingAnchor, LeftRightAnchor), (LeadingTailingAnchor, Normal),
         (LeftRightAnchor, LeadingTailingAnchor), (Normal, LeadingTailingAnchor):
        NSException(name: NSInvalidArgumentException,
                    reason: "if not all horizontal attributes, no way to translate `leading` or 'trailing'. so crashs you and here is what apple says: A constraint cannot be made between a leading/trailing attribute and a right/left attribute. Use leading/trailing for both or neither.",
                    userInfo: nil).raise()
    default:    // let apple crash you in other issues.
        break
    }
}
