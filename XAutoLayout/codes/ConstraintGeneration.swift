//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


/// x attribute container protocol
public protocol XAttributeContainer {
    /// change the **constant** of result constraint.
    func xc(c: CGFloat) -> XAttributeX
    /// change the **multiplier** of result constraint.
    func xm(m: CGFloat) -> XAttributeX
    /// change the **priority** of result constraint.
    func xp(p: UILayoutPriority) -> XAttributeX
    
    /**
     generate **XAttributeX** to construct constraint.
     
     **IMPORTANT:** you should not call this method directly. and this is the only method you should provide your own implementation.
     
     all other methods are provided with default implementation, and you should not provide your own.
     */
    func xGenerateX() -> XAttributeX
}

public extension XAttributeContainer {
    func xc(c: CGFloat) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), constant: c)
    }
    func xm(m: CGFloat) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), multiplier: m)
    }
    func xp(p: UILayoutPriority) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), priority: p)
    }
}


/**
 defines the relations that first item can make.
 
 **IMPORTANT:** if you chose to conform this protocol just only implement `generateX`. 
 
 all other methods are provided with default implementation, and you should not provide your own.
 */
public protocol XRelationMakeable: XAttributeContainer {
    func xEqual(other: XAttributeContainer) -> NSLayoutConstraint
    func xLessOrEqual(other: XAttributeContainer) -> NSLayoutConstraint
    func xGreaterOrEqual(other: XAttributeContainer) -> NSLayoutConstraint
}

public extension XRelationMakeable {
    public func xEqual(other: XAttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .Equal, right: other)
    }
    
    public func xLessOrEqual(other: XAttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .LessThanOrEqual, right: other)
    }
    
    public func xGreaterOrEqual(other: XAttributeContainer) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .GreaterThanOrEqual, right: other)
    }
}


infix operator =/ {}
infix operator <=/ {}
infix operator >=/ {}

public func =/(left: XRelationMakeable, right: XAttributeContainer) -> NSLayoutConstraint { return left.xEqual(right) }
public func <=/(left: XRelationMakeable, right: XAttributeContainer) -> NSLayoutConstraint { return left.xLessOrEqual(right) }
public func >=/(left: XRelationMakeable, right: XAttributeContainer) -> NSLayoutConstraint { return left.xGreaterOrEqual(right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XRelationMakeable], right: [XRelationMakeable]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XRelationMakeable], right: [XRelationMakeable?]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XRelationMakeable], right: [XAttributeContainer]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XRelationMakeable], right: [XAttributeContainer?]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }


// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [XRelationMakeable], _ right: [XRelationMakeable]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as XAttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [XRelationMakeable], _ right: [XRelationMakeable?]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as XAttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [XRelationMakeable], _ right: [XAttributeContainer]) -> [NSLayoutConstraint] {
    return compositeEqual(left, right.map{$0 as XAttributeContainer?})
}

// **zip** *left* array and *right* array to make constraints.
public func compositeEqual(left: [XRelationMakeable], _ right: [XAttributeContainer?]) -> [NSLayoutConstraint] {
    return zip(left, right).filter{ $0.1 != nil }.map { $0.0.xEqual($0.1!) }
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
    
    func make(left:XRelationMakeable, relation: NSLayoutRelation, right: XAttributeContainer) -> NSLayoutConstraint {
        let (first, second) = adjustAttributes(first: left.xGenerateX(), second: right.xGenerateX())
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
