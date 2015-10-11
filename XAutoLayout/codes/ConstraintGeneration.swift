
import UIKit

public protocol _RelationMakeable: AttributeContainer {
    func equal(other: AttributeContainer) -> NSLayoutConstraint
    func lessOrEqual(other: AttributeContainer) -> NSLayoutConstraint
    func greaterOrEqual(other: AttributeContainer) -> NSLayoutConstraint
}

public protocol RelationMakeable: _RelationMakeable {}

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

public func =/(left: [RelationMakeable], right: [RelationMakeable]) -> [NSLayoutConstraint] { return compositeEqual(left, right.map{$0 as AttributeContainer}) }
public func =/(left: [RelationMakeable], right: [AttributeContainer?]) -> [NSLayoutConstraint] { return compositeEqual(left, right) }

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

public func xmakeConstraints(direction: Direction = .LeadingToTrailing, autoActive: Bool = true, _ construction: ()->Void) -> [NSLayoutConstraint] {
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
        let (firstAttr, secondAttr) = (adjust(attributes.firstAttr), adjust(attributes.secondAttr))
        
        // constant. very important logic. no why, but just as apple do.
        if attributes.firstAttr != firstAttr && direction == .RightToLeft {
            attributes.constant = -attributes.constant
        }
        (attributes.firstAttr, attributes.secondAttr) = (firstAttr, secondAttr)
        
        return (XAttributeX(other: first, attr: attributes.firstAttr), XAttributeX(other: second, item: attributes.secondItem, attr: attributes.secondAttr, constant: attributes.constant))
    }
}
