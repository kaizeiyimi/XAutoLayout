//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

public protocol Anchor {
    associatedtype AnchorType: AnyObject
    func makeExtendedAnchor() -> ExtendedAnchor<AnchorType>
}

public protocol NSAnchor: Anchor {}

// MARK: - ExtendedAnchor

public final class ExtendedAnchor<AnchorType: AnyObject>: Anchor {
    let anchor: AnchorType
    
    let constant: CGFloat
    let multiplier: CGFloat
    let priority: UILayoutPriority
    
    init(_ anchor: AnchorType, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.anchor = anchor
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
    
    convenience init(_ other: ExtendedAnchor, constant: CGFloat? = nil, multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil) {
        self.init(other.anchor,
                  constant: constant ?? other.constant,
                  multiplier: multiplier ?? other.multiplier,
                  priority: priority ?? other.priority)
    }
    
    public func makeExtendedAnchor() -> ExtendedAnchor<AnchorType> {
        return self
    }
}

// MARK: -

extension NSLayoutXAxisAnchor: NSAnchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor<NSLayoutXAxisAnchor> {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedAnchor<NSLayoutXAxisAnchor> {
        return ExtendedAnchor(self, constant: constant)
    }
    
//    public func p(_ priority: Float) -> ExtendedAnchor<NSLayoutXAxisAnchor> {
//        return ExtendedAnchor(self, priority: UILayoutPriority(rawValue: priority))
//    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedAnchor<NSLayoutXAxisAnchor> {
        return ExtendedAnchor(self, priority: priority)
    }
}

extension NSLayoutYAxisAnchor: NSAnchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor<NSLayoutYAxisAnchor> {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedAnchor<NSLayoutYAxisAnchor> {
        return ExtendedAnchor(self, constant: constant)
    }
    
//    public func p(_ priority: Float) -> ExtendedAnchor<NSLayoutYAxisAnchor> {
//        return ExtendedAnchor(self, priority: UILayoutPriority(rawValue: priority))
//    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedAnchor<NSLayoutYAxisAnchor> {
        return ExtendedAnchor(self, priority: priority)
    }
}

extension NSLayoutDimension: NSAnchor {
    public typealias AnchorType = NSLayoutDimension
    
    public func makeExtendedAnchor() -> ExtendedAnchor<NSLayoutDimension> {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedAnchor<NSLayoutDimension> {
        return ExtendedAnchor(self, constant: constant)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedAnchor<NSLayoutDimension> {
        return ExtendedAnchor(self, multiplier: multiplier)
    }
    
//    public func p(_ priority: Float) -> ExtendedAnchor<NSLayoutDimension> {
//        return ExtendedAnchor(self, priority: UILayoutPriority(rawValue: priority))
//    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedAnchor<NSLayoutDimension> {
        return ExtendedAnchor(self, priority: priority)
    }
}

extension ExtendedAnchor {
    public func c(_ constant: CGFloat) -> ExtendedAnchor<AnchorType> {
        return ExtendedAnchor(self, constant: constant)
    }
    
//    public func p(_ priority: Float) -> ExtendedAnchor<AnchorType> {
//        return ExtendedAnchor(self, priority: UILayoutPriority(rawValue: priority))
//    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedAnchor<AnchorType> {
        return ExtendedAnchor(self, priority: priority)
    }
}

extension ExtendedAnchor where AnchorType: NSLayoutDimension {
    public func m(_ multiplier: CGFloat) -> ExtendedAnchor<AnchorType> {
        return ExtendedAnchor(self, multiplier: multiplier)
    }
}
