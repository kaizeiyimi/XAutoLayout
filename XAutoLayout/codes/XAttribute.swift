//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

/// x attribute container protocol
public protocol _AttributeContainer {
    /// change the **constant** of result constraint.
    func c(c: CGFloat) -> XAttributeX
    /// change the **multiplier** of result constraint.
    func m(m: CGFloat) -> XAttributeX
    /// change the **priority** of result constraint.
    func p(p: UILayoutPriority) -> XAttributeX
    
    /// generate **XAttributeX** to construct constraint.
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
    
    /// init with other **XAttributeX** variable. additional property will be used if provided.
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
