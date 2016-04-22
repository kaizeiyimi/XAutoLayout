//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


extension UIView {
    public var xLeft: XRelationMakeable { return XAttribute(item: self, attr: .Left) }
    public var xRight: XRelationMakeable { return XAttribute(item: self, attr: .Right) }
    public var xTop: XRelationMakeable { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XRelationMakeable { return XAttribute(item: self, attr: .Bottom) }
    public var xLeading: XRelationMakeable { return XAttribute(item: self, attr: .Leading) }
    public var xTrailing: XRelationMakeable { return XAttribute(item: self, attr: .Trailing) }
    public var xWidth: XRelationMakeable { return XAttribute(item: self, attr: .Width) }
    public var xHeight: XRelationMakeable { return XAttribute(item: self, attr: .Height) }
    public var xCenterX: XRelationMakeable { return XAttribute(item: self, attr: .CenterX) }
    public var xCenterY: XRelationMakeable { return XAttribute(item: self, attr: .CenterY) }
    public var xBaseline: XRelationMakeable { return XAttribute(item: self, attr: .Baseline) }
    public var xLastBaseline: XRelationMakeable { return XAttribute(item: self, attr: .LastBaseline) }

    @available(iOS 8.0, *)
    public var xLeftMargin: XRelationMakeable { return XAttribute(item: self, attr: .LeftMargin) }
    @available(iOS 8.0, *)
    public var xRightMargin: XRelationMakeable { return XAttribute(item: self, attr: .RightMargin) }
    @available(iOS 8.0, *)
    public var xTopMargin: XRelationMakeable { return XAttribute(item: self, attr: .TopMargin) }
    @available(iOS 8.0, *)
    public var xBottomMargin: XRelationMakeable { return XAttribute(item: self, attr: .BottomMargin) }
    @available(iOS 8.0, *)
    public var xLeadingMargin: XRelationMakeable { return XAttribute(item: self, attr: .LeadingMargin) }
    @available(iOS 8.0, *)
    public var xTrailingMargin: XRelationMakeable { return XAttribute(item: self, attr: .TrailingMargin) }
    @available(iOS 8.0, *)
    public var xCenterXWithinMargins: XRelationMakeable { return XAttribute(item: self, attr: .CenterXWithinMargins) }
    @available(iOS 8.0, *)
    public var xCenterYWithinMargins: XRelationMakeable { return XAttribute(item: self, attr: .CenterYWithinMargins) }
}


extension UILayoutSupport {
    public var xTop: XRelationMakeable { return XAttribute(item: self, attr: .Top) }
    public var xBottom: XRelationMakeable { return XAttribute(item: self, attr: .Bottom) }
    public var xHeight: XRelationMakeable { return XAttribute(item: self, attr: .Height) }
}


@available(iOS 9.0, *)
extension NSLayoutAnchor: XRelationMakeable {
    public func xGenerate() -> XAttribute {
        let item = valueForKey("item")!
        let attr = NSLayoutAttribute(rawValue: valueForKey("attr") as! Int)!
        return XAttribute(item: item, attr: attr)
    }
}


extension UIView {
    
    /// provide **[xWidth, xHeight]** array.
    public var xSize: [XRelationMakeable] {
        return [xWidth, xHeight]
    }
    
    /// provide **[xCenterX, xCenterY]** array.
    public var xCenter: [XRelationMakeable] {
        return [xCenterX, xCenterY]
    }
    
    /// provide **[xCenterXWithinMargins, xCenterYWithinMargins]** array.
    @available(iOS 8.0, *)
    public var xCenterWithinMargins: [XRelationMakeable] {
        return [xCenterXWithinMargins, xCenterYWithinMargins]
    }
    
    /// provide **[xTop, xLeading, xBottom, xTrailing]** array.
    public var xEdge: [XRelationMakeable] {
        return [xTop, xLeading, xBottom, xTrailing]
    }
    
    /// provide **[xTop, xLeft, xBottom, xRight]** array.
    public var xEdgeLR: [XRelationMakeable] {
        return [xTop, xLeft, xBottom, xRight]
    }
    
}
