
import UIKit

public protocol _AttributeContainer {
    func c(c: CGFloat) -> XAttributeX
    func m(m: CGFloat) -> XAttributeX
    func p(p: UILayoutPriority) -> XAttributeX
    
    func generateX() -> XAttributeX
}

public protocol AttributeContainer: _AttributeContainer {}

public extension AttributeContainer {
    func c(c: CGFloat) -> XAttributeX {
        return XAttributeX(other: generateX(), constant: c)
    }
    func m(m: CGFloat) -> XAttributeX {
        return XAttributeX(other: generateX(), multiplier: m)
    }
    func p(p: UILayoutPriority) -> XAttributeX {
        return XAttributeX(other: generateX(), priority: p)
    }
}


public struct XAttribute: AttributeContainer {
    let item: AnyObject
    let attr: NSLayoutAttribute
    
    public init(item: AnyObject, attr: NSLayoutAttribute) {
        self.item = item
        self.attr = attr
    }
    
    public func generateX() -> XAttributeX {
        return XAttributeX(item: item, attr: attr)
    }
}

public struct XAttributeX: AttributeContainer {
    let item: AnyObject?
    let attr: NSLayoutAttribute
    
    let constant: CGFloat
    let multiplier: CGFloat
    let priority: UILayoutPriority
    
    public init(item: AnyObject?, attr: NSLayoutAttribute, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.item = item
        self.attr = attr
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
    
    public init(other: XAttributeX, item: AnyObject? = nil, attr: NSLayoutAttribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil) {
        self.item = item ?? other.item
        self.attr = attr ?? other.attr
        self.constant = constant ?? other.constant
        self.multiplier = multiplier ?? other.multiplier
        self.priority = priority ?? other.priority
    }
    
    public func generateX() -> XAttributeX {
        return self
    }
}
