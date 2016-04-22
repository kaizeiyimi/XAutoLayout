//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


/**
 make constraints. *direction* and *autoActive* can be specified to adjust constraints.
 
 **IMPORTANT:** 
 * I just change the writing way of creating constraints in code, and add only one additional ability: use superview if number is second item and first item is UIView and layout attribute is not dimension.
 
 
 * when working with Direction, we change Leading/Trailing to Left/Right as VFL do if needed,
 but have no idea about should change or not when only one attribute is Leading/Trailing **and** direction is L2R or R2L **and** another is not horizontal anchor.
 so I will crash you.
 
 **NOTICE:**
 
 system has some strange behavior like it allows Top and Left to have a constraint,
 and iOS9 will **crash** if constraint is made between **Leading/Trailing to Left/Right**, while iOS8 will not.
 It has no problem between **Leading/Trailing** and other **non-dimension** anchors (dimension anchors will give an exception **"`Invalid pairing of layout attributes`"**).
 
 so, you would better follow a normal layout mind, do not try any tricky things.
 */
public func xmakeConstraints(direction: Direction = .LeadingToTrailing, autoActive: Bool = true, @noescape _ construction: ()->Void) -> [NSLayoutConstraint] {
    Context.stack.append(Context(direction: direction, autoActive: autoActive))
    construction()
    return Context.stack.removeLast().constraints
}


public protocol XRightItem {
    /**
     generate **XAttributeX** to construct constraint.
     
     **IMPORTANT:** you should not call this method directly. and this is the only method you should provide your own implementation.
     
     all other methods are provided with default implementation, and you should not provide your own.
     */
    func xGenerateX() -> XAttributeX
}


public extension XRightItem {
    /// change the **constant** of result constraint.
    public func xc(c: CGFloat) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), constant: c)
    }
    
    /**
     change the **multiplier** of result constraint.
     
     NOTICE: when use with `number`, **`multiplier`** is ignored by iOS.
     ```
     // the view's height will be 10 not 20.
     NSLayoutConstraint(item: view, 
                        attribute: .Height,
                        relatedBy: .Equal,
                        toItem: nil,
                        attribute: .NotAnAttribute,
                        multiplier: 2,
                        constant: 10)
     ```
     That's to say 10.xm(2) has no effect, the constant will still be 10. I just follow system's behavior.
     */
    public func xm(m: CGFloat) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), multiplier: m)
    }
    /// change the **priority** of result constraint.
    public func xp(p: UILayoutPriority) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), priority: p)
    }
}


/// leftItem can be rightItem too, but rightItem cannot be leftItem.
public protocol XLeftItem: XRightItem {
    /**
     **IMPORTANT:** if you chose to conform this protocol just only implement **`xGenerate`**.
     
     all other methods are provided with default implementation, and you should not provide your own.
     */
    func xGenerate() -> XAttribute
}


public extension XLeftItem {
    /// make `equal` relation to other.
    public func xEqual(other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .Equal, right: other)
    }
    /// make `less or equal` relation to other.
    public func xLessOrEqual(other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .LessThanOrEqual, right: other)
    }
    /// make `greater or equal` relation to other.
    public func xGreaterOrEqual(other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(self, relation: .GreaterThanOrEqual, right: other)
    }
    
    public func xGenerateX() -> XAttributeX {
        let attribute = xGenerate()
        return XAttributeX(item: attribute.item, attr: attribute.attr)
    }
}


infix operator =/ {}
infix operator <=/ {}
infix operator >=/ {}

public func =/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xEqual(right) }
public func <=/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xLessOrEqual(right) }
public func >=/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xGreaterOrEqual(right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XLeftItem], right: [XLeftItem]) -> [NSLayoutConstraint] { return xEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XLeftItem], right: [XLeftItem?]) -> [NSLayoutConstraint] { return xEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XLeftItem], right: [XRightItem]) -> [NSLayoutConstraint] { return xEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
public func =/(left: [XLeftItem], right: [XRightItem?]) -> [NSLayoutConstraint] { return xEqual(left, right) }


// **zip** *left* array and *right* array to make constraints.
public func xEqual(left: [XLeftItem], _ right: [XLeftItem]) -> [NSLayoutConstraint] {
    return xEqual(left, right.map{$0 as XRightItem?})
}

// **zip** *left* array and *right* array to make constraints.
public func xEqual(left: [XLeftItem], _ right: [XLeftItem?]) -> [NSLayoutConstraint] {
    return xEqual(left, right.map{$0 as XRightItem?})
}

// **zip** *left* array and *right* array to make constraints.
public func xEqual(left: [XLeftItem], _ right: [XRightItem]) -> [NSLayoutConstraint] {
    return xEqual(left, right.map{$0 as XRightItem?})
}

// **zip** *left* array and *right* array to make constraints.
public func xEqual(left: [XLeftItem], _ right: [XRightItem?]) -> [NSLayoutConstraint] {
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


private class Context {
    let direction: Direction
    let autoActive: Bool
    var constraints: [NSLayoutConstraint] = []
    
    static var stack: [Context] = [Context()]
    
    init(direction: Direction = .LeadingToTrailing, autoActive: Bool = false) {
        self.direction = direction
        self.autoActive = autoActive
    }
    
    func make(left:XLeftItem, relation: NSLayoutRelation, right: XRightItem) -> NSLayoutConstraint {
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
