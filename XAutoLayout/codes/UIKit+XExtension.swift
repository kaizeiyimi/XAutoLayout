//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


extension UIView {
    public var xLeft: XLeftItem { return XAttribute(item: self, attr: .Left) }
    public var xRight: XLeftItem { return XAttribute(item: self, attr: .Right) }
    public var xTop: XLeftItem { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XLeftItem { return XAttribute(item: self, attr: .Bottom) }
    public var xLeading: XLeftItem { return XAttribute(item: self, attr: .Leading) }
    public var xTrailing: XLeftItem { return XAttribute(item: self, attr: .Trailing) }
    public var xWidth: XLeftItem { return XAttribute(item: self, attr: .Width) }
    public var xHeight: XLeftItem { return XAttribute(item: self, attr: .Height) }
    public var xCenterX: XLeftItem { return XAttribute(item: self, attr: .CenterX) }
    public var xCenterY: XLeftItem { return XAttribute(item: self, attr: .CenterY) }
    public var xBaseline: XLeftItem { return XAttribute(item: self, attr: .Baseline) }
    public var xLastBaseline: XLeftItem { return XAttribute(item: self, attr: .LastBaseline) }

    @available(iOS 8.0, *)
    public var xLeftMargin: XLeftItem { return XAttribute(item: self, attr: .LeftMargin) }
    @available(iOS 8.0, *)
    public var xRightMargin: XLeftItem { return XAttribute(item: self, attr: .RightMargin) }
    @available(iOS 8.0, *)
    public var xTopMargin: XLeftItem { return XAttribute(item: self, attr: .TopMargin) }
    @available(iOS 8.0, *)
    public var xBottomMargin: XLeftItem { return XAttribute(item: self, attr: .BottomMargin) }
    @available(iOS 8.0, *)
    public var xLeadingMargin: XLeftItem { return XAttribute(item: self, attr: .LeadingMargin) }
    @available(iOS 8.0, *)
    public var xTrailingMargin: XLeftItem { return XAttribute(item: self, attr: .TrailingMargin) }
    @available(iOS 8.0, *)
    public var xCenterXWithinMargins: XLeftItem { return XAttribute(item: self, attr: .CenterXWithinMargins) }
    @available(iOS 8.0, *)
    public var xCenterYWithinMargins: XLeftItem { return XAttribute(item: self, attr: .CenterYWithinMargins) }
}


extension UILayoutSupport {
    public var xTop: XLeftItem { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XLeftItem { return XAttribute(item: self, attr: .Bottom) }
    public var xHeight: XLeftItem { return XAttribute(item: self, attr: .Height) }
    
    public subscript (attrs: NSLayoutAttribute...) -> [XLeftItem] {
        return attrs.map { XAttribute(item: self, attr: $0) }
    }
}


@available(iOS 9.0, *)
extension NSLayoutAnchor: XLeftItem {
    public func xGenerate() -> XAttribute {
        let item = valueForKey("item")!
        let attr = NSLayoutAttribute(rawValue: valueForKey("attr") as! Int)!
        return XAttribute(item: item, attr: attr)
    }
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
