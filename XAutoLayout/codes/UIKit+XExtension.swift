//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


extension UIView {
    public var xLeft: XLeftItem { return XAttribute(item: self, attr: .left) }
    public var xRight: XLeftItem { return XAttribute(item: self, attr: .right) }
    public var xTop: XLeftItem { return XAttribute(item: self, attr: .top) }
    public var xBottom: XLeftItem { return XAttribute(item: self, attr: .bottom) }
    public var xLeading: XLeftItem { return XAttribute(item: self, attr: .leading) }
    public var xTrailing: XLeftItem { return XAttribute(item: self, attr: .trailing) }
    public var xWidth: XLeftItem { return XAttribute(item: self, attr: .width) }
    public var xHeight: XLeftItem { return XAttribute(item: self, attr: .height) }
    public var xCenterX: XLeftItem { return XAttribute(item: self, attr: .centerX) }
    public var xCenterY: XLeftItem { return XAttribute(item: self, attr: .centerY) }
    public var xLastBaseline: XLeftItem { return XAttribute(item: self, attr: .lastBaseline) }

    @available(iOS 8.0, *)
    public var xFirstBaseline: XLeftItem { return XAttribute(item: self, attr: .firstBaseline) }
    @available(iOS 8.0, *)
    public var xLeftMargin: XLeftItem { return XAttribute(item: self, attr: .leftMargin) }
    @available(iOS 8.0, *)
    public var xRightMargin: XLeftItem { return XAttribute(item: self, attr: .rightMargin) }
    @available(iOS 8.0, *)
    public var xTopMargin: XLeftItem { return XAttribute(item: self, attr: .topMargin) }
    @available(iOS 8.0, *)
    public var xBottomMargin: XLeftItem { return XAttribute(item: self, attr: .bottomMargin) }
    @available(iOS 8.0, *)
    public var xLeadingMargin: XLeftItem { return XAttribute(item: self, attr: .leadingMargin) }
    @available(iOS 8.0, *)
    public var xTrailingMargin: XLeftItem { return XAttribute(item: self, attr: .trailingMargin) }
    @available(iOS 8.0, *)
    public var xCenterXWithinMargins: XLeftItem { return XAttribute(item: self, attr: .centerXWithinMargins) }
    @available(iOS 8.0, *)
    public var xCenterYWithinMargins: XLeftItem { return XAttribute(item: self, attr: .centerYWithinMargins) }
}


extension UILayoutSupport {
    public var xTop: XLeftItem { return XAttribute(item: self, attr: .top) }
    public var xBottom: XLeftItem { return XAttribute(item: self, attr: .bottom) }
    public var xHeight: XLeftItem { return XAttribute(item: self, attr: .height) }
    
    public subscript (attrs: NSLayoutAttribute...) -> [XLeftItem] {
        return attrs.map { XAttribute(item: self, attr: $0) }
    }
}


@available(iOS 9.0, *)
extension NSLayoutXAxisAnchor: XLeftItem {
    public func xGenerate() -> XAttribute {
        return generateXAttribute(forAnchor: self)
    }
}

@available(iOS 9.0, *)
extension NSLayoutYAxisAnchor: XLeftItem {
    public func xGenerate() -> XAttribute {
        return generateXAttribute(forAnchor: self)
    }
}

@available(iOS 9.0, *)
extension NSLayoutDimension: XLeftItem {
    public func xGenerate() -> XAttribute {
        return generateXAttribute(forAnchor: self)
    }
}

@available(iOS 9.0, *)
private func generateXAttribute<T: AnyObject>(forAnchor anchor: NSLayoutAnchor<T>) -> XAttribute {
    let item = anchor.value(forKey: "item")!
    let attr = NSLayoutAttribute(rawValue: anchor.value(forKey: "attr") as! Int)!
    return XAttribute(item: item as AnyObject, attr: attr)
}

/**
 just some easy wrapper. you can use array like [xLeading, xTop] =/ [10, 20].
 */
extension UIView {
    
    /// provide **[xWidth, xHeight]** array.
    public var xSize: [XLeftItem] {
        return [xWidth, xHeight]
    }
    
    /// provide **[xCenterX, xCenterY]** array.
    public var xCenter: [XLeftItem] {
        return [xCenterX, xCenterY]
    }
    
    /// provide **[xCenterXWithinMargins, xCenterYWithinMargins]** array.
    @available(iOS 8.0, *)
    public var xCenterWithinMargins: [XLeftItem] {
        return [xCenterXWithinMargins, xCenterYWithinMargins]
    }
    
    /// provide **[xTop, xLeading, xBottom, xTrailing]** array.
    public var xEdge: [XLeftItem] {
        return [xTop, xLeading, xBottom, xTrailing]
    }
    
    /// provide **[xTop, xLeft, xBottom, xRight]** array.
    public var xEdgeLR: [XLeftItem] {
        return [xTop, xLeft, xBottom, xRight]
    }
    
    public subscript (attrs: NSLayoutAttribute...) -> [XLeftItem] {
        return attrs.map { XAttribute(item: self, attr: $0) }
    }
    
}
