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
@discardableResult
public func xmakeConstraints(direction: Direction = .leadingToTrailing, autoActive: Bool = true, _ construction: ()->Void) -> [NSLayoutConstraint] {
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
    public func xc(_ c: CGFloat) -> XAttributeX {
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
    public func xm(_ m: CGFloat) -> XAttributeX {
        return XAttributeX(other: xGenerateX(), multiplier: m)
    }
    /// change the **priority** of result constraint.
    public func xp(_ p: UILayoutPriority) -> XAttributeX {
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
    @discardableResult
    public func xEqual(_ other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(left: self, relation: .equal, right: other)
    }
    /// make `less or equal` relation to other.
    @discardableResult
    public func xLessOrEqual(_ other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(left: self, relation: .lessThanOrEqual, right: other)
    }
    /// make `greater or equal` relation to other.
    @discardableResult
    public func xGreaterOrEqual(_ other: XRightItem) -> NSLayoutConstraint {
        return Context.stack.last!.make(left: self, relation: .greaterThanOrEqual, right: other)
    }
    
    public func xGenerateX() -> XAttributeX {
        return XAttributeX(leftItem: self)
    }
}


infix operator =/
infix operator <=/
infix operator >=/

@discardableResult
public func =/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xEqual(right) }
@discardableResult
public func <=/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xLessOrEqual(right) }
@discardableResult
public func >=/(left: XLeftItem, right: XRightItem) -> NSLayoutConstraint { return left.xGreaterOrEqual(right) }


// **zip** *left* array and *right* array to make constraints.
@discardableResult
public func =/(left: [XLeftItem], right: [XRightItem?]) -> [NSLayoutConstraint] { return xEqual(left, right) }

// **zip** *left* array and *right* array to make constraints.
@discardableResult
public func xEqual(_ left: [XLeftItem], _ right: [XRightItem?]) -> [NSLayoutConstraint] {
    return zip(left, right).filter{ $0.1 != nil }.map { $0.0.xEqual($0.1!) }
}


public enum Direction {
    case leadingToTrailing
    case leftToRight
    case rightToLeft
    
    public init?(_ layoutFormatOption: NSLayoutFormatOptions) {
        switch layoutFormatOption {
        case NSLayoutFormatOptions(): self = .leadingToTrailing
        case NSLayoutFormatOptions.directionLeftToRight: self = .leftToRight
        case NSLayoutFormatOptions.directionRightToLeft: self = .rightToLeft
        default: return nil
        }
    }
    
    public var layoutFormatOption: NSLayoutFormatOptions {
        switch self {
        case .leadingToTrailing: return NSLayoutFormatOptions()
        case .leftToRight: return NSLayoutFormatOptions.directionLeftToRight
        case .rightToLeft: return NSLayoutFormatOptions.directionRightToLeft
        }
    }
}


private class Context {
    let direction: Direction
    let autoActive: Bool
    var constraints: [NSLayoutConstraint] = []
    
    static var stack: [Context] = [Context()]
    
    init(direction: Direction = .leadingToTrailing, autoActive: Bool = false) {
        self.direction = direction
        self.autoActive = autoActive
    }
    
    func make(left:XLeftItem, relation: NSLayoutRelation, right: XRightItem) -> NSLayoutConstraint {
        let (first, second) = adjustAttributes(first: XAttributeX(leftItem: left), second: right.xGenerateX())
        let constraint = NSLayoutConstraint(item: first.item!, attribute: first.attr, relatedBy: relation, toItem: second.item, attribute: second.attr, multiplier: second.multiplier, constant: second.constant)
        constraint.priority = second.priority
        constraint.isActive = autoActive
        constraints.append(constraint)
        return constraint
    }
    
    func adjustAttributes(first: XAttributeX, second: XAttributeX) -> (first: XAttributeX, second: XAttributeX) {
        crashIfNeeded(firstAttr: first.attr, secondAttr: second.attr, direction: direction)
        var firstItem = first.item!, firstAttr = first.attr, secondItem = second.item, secondAttr = second.attr, constant = second.constant
        // number
        if firstAttr != .width && firstAttr != .height && secondItem == nil && secondAttr == .notAnAttribute {
            if let firstView = firstItem as? UIView {
                secondItem = firstView.superview
                secondAttr = firstAttr
            }
        }
        // direction
        func adjust(_ attr: NSLayoutAttribute) -> NSLayoutAttribute {
            switch attr {
            case .leading: return direction == .leftToRight ? .left : (direction == .rightToLeft ? .right : attr)
            case .leadingMargin: return direction == .leftToRight ? .leftMargin : (direction == .rightToLeft ? .rightMargin : attr)
            case .trailing: return direction == .leftToRight ? .right : (direction == .rightToLeft ? .left : attr)
            case .trailingMargin: return direction == .leftToRight ? .rightMargin : (direction == .rightToLeft ? .leftMargin : attr)
            default:
                return attr
            }
        }
        let (adjustedFirstAttr, adjustedSecondAttr) = (adjust(firstAttr), adjust(secondAttr))
        
        // constant convert. since pair is checked, here we only need to check firstAttr.
        if firstAttr != adjustedFirstAttr && direction == .rightToLeft {
            constant = -constant
        }
        (firstAttr, secondAttr) = (adjustedFirstAttr, adjustedSecondAttr)
        
        return (XAttributeX(other: first, attr: firstAttr), XAttributeX(other: second, item: secondItem, attr: secondAttr, constant: constant))
    }
}


// apple only check horizontal attr, and crashs app in iOS9 if pair is not satisfied.
private func crashIfNeeded(firstAttr: NSLayoutAttribute, secondAttr: NSLayoutAttribute, direction: Direction) {
    guard direction != .leadingToTrailing else { return }
    
    let Normal = 0, NotAnAttribute = 1, Dimension = 2, LeadingTailingAnchor = 3, LeftRightAnchor = 4
    func convert(_ attr: NSLayoutAttribute) -> Int {
        switch attr {
        case .leading, .leadingMargin, .trailing, .trailingMargin:
            return LeadingTailingAnchor
        case .left, .leftMargin, .right, .rightMargin:
            return LeftRightAnchor
        case .width, .height:
            return Dimension
        case .notAnAttribute:
            return NotAnAttribute
        default:
            return Normal
        }
    }
    switch (convert(firstAttr), convert(secondAttr)) {
    case (LeadingTailingAnchor, LeftRightAnchor), (LeadingTailingAnchor, Normal),
         (LeftRightAnchor, LeadingTailingAnchor), (Normal, LeadingTailingAnchor):
        NSException(name: NSExceptionName.invalidArgumentException,
                    reason: "if not all horizontal attributes, no way to translate `leading` or 'trailing'. so crashs you and here is what apple says: A constraint cannot be made between a leading/trailing attribute and a right/left attribute. Use leading/trailing for both or neither.",
                    userInfo: nil).raise()
    default:    // let apple crash you in other issues.
        break
    }
}
