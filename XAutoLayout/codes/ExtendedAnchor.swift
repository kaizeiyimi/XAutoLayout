//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

public protocol AnchorExtending {
    func makeExtendedAnchor() -> ExtendedAnchor
}

public protocol Anchor: AnchorExtending {
    associatedtype AnchorType: AnyObject
}

public protocol NSAnchor: Anchor {}

public protocol XAxisAnchor: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedXAxisAnchor
    func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor
}

public protocol YAxisAnchor: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedYAxisAnchor
    func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor
}

public protocol DimensionAnchor: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedDimensionAnchor
    func p(_ priority: UILayoutPriority) -> ExtendedDimensionAnchor
    func m(_ multiplier: CGFloat) -> ExtendedDimensionAnchor
}

// MARK: - ExtendedAnchor

public class ExtendedAnchor: AnchorExtending {
    let anchor: Any?
    
    let constant: CGFloat
    let multiplier: CGFloat
    let priority: UILayoutPriority
    
    init(_ anchor: Any?, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.anchor = anchor
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
    
    convenience init(extending other: ExtendedAnchor, constant: CGFloat? = nil, multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil) {
        self.init(other.anchor,
                  constant: constant ?? other.constant,
                  multiplier: multiplier ?? other.multiplier,
                  priority: priority ?? other.priority)
    }
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return self
    }
}


// MARK: - XAxis

public final class ExtendedXAxisAnchor: ExtendedAnchor, Anchor, XAxisAnchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    
    public func c(_ constant: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, priority: priority)
    }
    
}

extension NSLayoutXAxisAnchor: NSAnchor, XAxisAnchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, priority: priority)
    }
}

// MARK: - YAxis

public final class ExtendedYAxisAnchor: ExtendedAnchor, Anchor, YAxisAnchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    
    public func c(_ constant: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, priority: priority)
    }
    
}

extension NSLayoutYAxisAnchor: NSAnchor, YAxisAnchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, priority: priority)
    }
}

// MARK: - Dimension

public final class ExtendedDimensionAnchor: ExtendedAnchor, Anchor, DimensionAnchor {
    public typealias AnchorType = NSLayoutDimension
    
    public func c(_ constant: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(extending: self, priority: priority)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(extending: self, multiplier: multiplier)
    }
}

extension NSLayoutDimension: NSAnchor, DimensionAnchor {
    public typealias AnchorType = NSLayoutDimension
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(self, priority: priority)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(self, multiplier: multiplier)
    }
}

extension Int: Anchor, DimensionAnchor {}
extension Int8: Anchor, DimensionAnchor {}
extension Int16: Anchor, DimensionAnchor {}
extension Int32: Anchor, DimensionAnchor {}
extension Int64: Anchor, DimensionAnchor {}

extension UInt: Anchor, DimensionAnchor {}
extension UInt8: Anchor, DimensionAnchor {}
extension UInt16: Anchor, DimensionAnchor {}
extension UInt32: Anchor, DimensionAnchor {}
extension UInt64: Anchor, DimensionAnchor {}

extension Float: Anchor, DimensionAnchor {}
extension CGFloat: Anchor, DimensionAnchor {}
extension Double: Anchor, DimensionAnchor {}

extension Numeric {
    public typealias AnchorType = NSLayoutDimension
    
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(nil, constant: self.cgFloatValue)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(nil, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(nil, constant: self.cgFloatValue, priority: priority)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedDimensionAnchor {
        return ExtendedDimensionAnchor(nil, constant: self.cgFloatValue, multiplier: multiplier)
    }
    
    private var cgFloatValue: CGFloat {
        return CGFloat(("\(self)" as NSString).doubleValue)
    }
}
