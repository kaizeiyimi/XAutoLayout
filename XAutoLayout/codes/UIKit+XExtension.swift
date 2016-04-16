//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

extension UIView {
    public func xly(attr: NSLayoutAttribute) -> XAttribute {
        return XAttribute(item: self, attr: attr)
    }
    
    public var xLeft: XAttribute { return XAttribute(item: self, attr: .Left) }
    public var xRight: XAttribute { return XAttribute(item: self, attr: .Right) }
    public var xTop: XAttribute { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XAttribute { return XAttribute(item: self, attr: .Bottom) }
    public var xLeading: XAttribute { return XAttribute(item: self, attr: .Leading) }
    public var xTrailing: XAttribute { return XAttribute(item: self, attr: .Trailing) }
    public var xWidth: XAttribute { return XAttribute(item: self, attr: .Width) }
    public var xHeight: XAttribute { return XAttribute(item: self, attr: .Height) }
    public var xCenterX: XAttribute { return XAttribute(item: self, attr: .CenterX) }
    public var xCenterY: XAttribute { return XAttribute(item: self, attr: .CenterY) }
    public var xBaseline: XAttribute { return XAttribute(item: self, attr: .Baseline) }
    public var xLastBaseline: XAttribute { return XAttribute(item: self, attr: .LastBaseline) }

    @available(iOS 8.0, *)
    public var xLeftMargin: XAttribute { return XAttribute(item: self, attr: .LeftMargin) }
    @available(iOS 8.0, *)
    public var xRightMargin: XAttribute { return XAttribute(item: self, attr: .RightMargin) }
    @available(iOS 8.0, *)
    public var xTopMargin: XAttribute { return XAttribute(item: self, attr: .TopMargin) }
    @available(iOS 8.0, *)
    public var xBottomMargin: XAttribute { return XAttribute(item: self, attr: .BottomMargin) }
    @available(iOS 8.0, *)
    public var xLeadingMargin: XAttribute { return XAttribute(item: self, attr: .LeadingMargin) }
    @available(iOS 8.0, *)
    public var xTrailingMargin: XAttribute { return XAttribute(item: self, attr: .TrailingMargin) }
    @available(iOS 8.0, *)
    public var xCenterXWithinMargins: XAttribute { return XAttribute(item: self, attr: .CenterXWithinMargins) }
    @available(iOS 8.0, *)
    public var xCenterYWithinMargins: XAttribute { return XAttribute(item: self, attr: .CenterYWithinMargins) }
}


extension UILayoutSupport {
    public var xTop: XAttribute { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XAttribute { return XAttribute(item: self, attr: .Bottom) }
    public var xHeight: XAttribute { return XAttribute(item: self, attr: .Height) }
}


@available(iOS 9.0, *)
extension NSLayoutAnchor: RelationMakeable {
    public func generateX() -> XAttributeX {
        let item = valueForKey("item")!
        let attr = NSLayoutAttribute(rawValue: valueForKey("attr") as! Int)!
        return XAttributeX(item: item, attr: attr)
    }
}


extension UIView {
    
    /// provide **[xWidth, xHeight]** array.
    public var xSize: [RelationMakeable] {
        return [xWidth, xHeight]
    }
    
    /// provide **[xCenterX, xCenterY]** array.
    public var xCenter: [RelationMakeable] {
        return [xCenterX, xCenterY]
    }
    
    /// provide **[xCenterXWithinMargins, xCenterYWithinMargins]** array.
    @available(iOS 8.0, *)
    public var xCenterWithinMargins: [RelationMakeable] {
        return [xCenterXWithinMargins, xCenterYWithinMargins]
    }
    
    /// provide **[xTop, xLeading, xBottom, xTrailing]** array.
    public var xEdge: [RelationMakeable] {
        return [xTop, xLeading, xBottom, xTrailing]
    }
    
    /// provide **[xTop, xLeft, xBottom, xRight]** array.
    public var xEdgeLR: [RelationMakeable] {
        return [xTop, xLeft, xBottom, xRight]
    }
    
}
