//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


public final class XAttribute {
    let item: AnyObject
    let attr: NSLayoutAttribute
    
    public init(item: AnyObject, attr: NSLayoutAttribute) {
        self.item = item
        self.attr = attr
    }
}

public final class XAttributeX {
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
    convenience init(other: XAttributeX, item: AnyObject? = nil, attr: NSLayoutAttribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil) {
        self.init(item: item ?? other.item,
                  attr: attr ?? other.attr,
                  constant: constant ?? other.constant,
                  multiplier: multiplier ?? other.multiplier,
                  priority: priority ?? other.priority)
    }
    
    convenience init(leftItem: XLeftItem) {
        let attribute = leftItem.xGenerate()
        self.init(item: attribute.item, attr: attribute.attr)
    }
}


extension XAttribute: XLeftItem {
    public func xGenerate() -> XAttribute {
        return XAttribute(item: item, attr: attr)
    }
}


extension XAttributeX: XRightItem {
    public func xGenerateX() -> XAttributeX {
        return self
    }
}
